# frozen_string_literal: true

module Lokka
  # Migrates data from a legacy DataMapper-based Lokka database
  # to the new ActiveRecord schema.
  #
  # Usage:
  #   rake db:migrate_from_dm SOURCE=path/to/old/database.sqlite3
  #   rake db:migrate_from_dm SOURCE=postgres://user:pass@host/old_db
  #
  class DMMigrator
    TABLES_IN_ORDER = %w[
      sites users categories entries comments snippets
      tags taggings field_names fields options
    ].freeze

    # Column mappings: old_name => new_name (only where they differ)
    COLUMN_RENAMES = {
      'entries' => {
        'entry_tags' => nil  # skip dm-tags internal columns if present
      }
    }.freeze

    # Columns to skip during migration
    SKIP_COLUMNS = {
      'sites' => %w[mobile_theme]
    }.freeze

    def initialize(source_dsn)
      @source_dsn = source_dsn
    end

    def migrate!
      puts "=== Lokka DataMapper → ActiveRecord Migration ==="
      puts "Source: #{@source_dsn}"
      puts

      establish_source_connection!
      counts = {}

      TABLES_IN_ORDER.each do |table|
        count = migrate_table(table)
        counts[table] = count
        puts "  ✓ #{table}: #{count} records"
      end

      reset_sequences!

      puts
      puts "=== Migration Complete ==="
      counts.each { |t, c| puts "  #{t}: #{c} records" }
      puts
      puts "Total: #{counts.values.sum} records migrated"
    end

    private

    def establish_source_connection!
      # Set up a secondary connection to the old DB
      ActiveRecord::Base.connection_pool.disconnect!

      @source_config = parse_source_dsn(@source_dsn)
      ActiveRecord::Base.establish_connection(@source_config)

      # Verify we can read from it
      tables = ActiveRecord::Base.connection.tables
      puts "Source tables found: #{tables.join(', ')}"
      puts

      # Read all data first, then reconnect to target
      @source_data = {}
      TABLES_IN_ORDER.each do |table|
        if tables.include?(table)
          @source_data[table] = read_table(table)
        else
          puts "  ⚠ Table '#{table}' not found in source, skipping"
          @source_data[table] = []
        end
      end

      # Reconnect to the target (new) database
      ActiveRecord::Base.connection_pool.disconnect!
      target_config = Lokka.database_config
      ActiveRecord::Base.establish_connection(target_config)
    end

    def read_table(table)
      conn = ActiveRecord::Base.connection
      rows = conn.select_all("SELECT * FROM #{conn.quote_table_name(table)}")
      rows.to_a
    end

    def migrate_table(table)
      rows = @source_data[table]
      return 0 if rows.empty?

      conn = ActiveRecord::Base.connection
      target_tables = conn.tables
      unless target_tables.include?(table)
        puts "  ⚠ Target table '#{table}' doesn't exist, skipping"
        return 0
      end

      target_columns = conn.columns(table).map(&:name)
      skip_cols = SKIP_COLUMNS[table] || []

      count = 0
      rows.each do |row|
        # Filter to only columns that exist in the target schema
        filtered = row.select { |k, _v| target_columns.include?(k) && !skip_cols.include?(k) }
        next if filtered.empty?

        columns = filtered.keys
        values = filtered.values

        # Handle the options table (no auto-increment id)
        placeholders = values.map { '?' }.join(', ')
        quoted_columns = columns.map { |c| conn.quote_column_name(c) }.join(', ')

        sql = "INSERT INTO #{conn.quote_table_name(table)} (#{quoted_columns}) VALUES (#{placeholders})"

        begin
          conn.exec_insert(sql, "#{table} INSERT", values.map.with_index { |v, i|
            ActiveRecord::Relation::QueryAttribute.new(columns[i], v, ActiveRecord::Type::Value.new)
          })
          count += 1
        rescue ActiveRecord::RecordNotUnique => e
          puts "  ⚠ Duplicate in #{table}, skipping: #{e.message.truncate(80)}"
        rescue StandardError => e
          puts "  ✗ Error in #{table}: #{e.message.truncate(120)}"
        end
      end

      count
    end

    def reset_sequences!
      conn = ActiveRecord::Base.connection
      return unless conn.adapter_name =~ /PostgreSQL/i

      puts
      puts "Resetting PostgreSQL sequences..."
      TABLES_IN_ORDER.each do |table|
        next if table == 'options' # no serial id
        next unless conn.tables.include?(table)

        begin
          max_id = conn.select_value("SELECT MAX(id) FROM #{conn.quote_table_name(table)}")
          if max_id
            conn.execute("SELECT setval(pg_get_serial_sequence('#{table}', 'id'), #{max_id})")
          end
        rescue StandardError
          # Table might not have an id column
        end
      end
    end

    def parse_source_dsn(dsn)
      if dsn =~ /\Asqlite3?:\/\//
        path = dsn.sub(%r{\Asqlite3?://}, '')
        { adapter: 'sqlite3', database: path }
      elsif dsn =~ /\Apostgres(ql)?:\/\//
        { adapter: 'postgresql', url: dsn }
      elsif dsn =~ /\Amysql2?:\/\//
        { adapter: 'mysql2', url: dsn }
      elsif File.exist?(dsn)
        # Assume it's a SQLite file path
        { adapter: 'sqlite3', database: File.expand_path(dsn) }
      else
        raise "Unknown source DSN format: #{dsn}. Use sqlite3://path, postgres://..., mysql://..., or a file path."
      end
    end
  end
end
