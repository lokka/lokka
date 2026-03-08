# frozen_string_literal: true

require 'json'

module Lokka
  # Migrates data from a legacy DataMapper-based Lokka database
  # to the new ActiveRecord schema using a two-step dump/import approach.
  #
  # Step 1 - Dump (run on old environment):
  #   rake db:dump_dm SOURCE=path/to/old/database.sqlite3
  #   Produces db/dm_dump.json
  #
  # Step 2 - Import (run on new environment):
  #   rake db:import_dm
  #   Reads db/dm_dump.json and imports into the new schema
  #
  class DMMigrator
    DUMP_FILE = File.expand_path('../../db/dm_dump.json', __dir__).freeze

    TABLES_IN_ORDER = %w[
      sites users categories entries comments snippets
      tags taggings field_names fields options
    ].freeze

    # Column mappings: old_name => new_name (only where they differ)
    COLUMN_RENAMES = {
      'entries' => {
        'entry_tags' => nil # skip dm-tags internal columns if present
      }
    }.freeze

    # Columns to skip during migration
    SKIP_COLUMNS = {
      'sites' => %w[mobile_theme]
    }.freeze

    # --- Dump phase (old environment) ---

    def self.dump!(source_dsn)
      new.dump!(source_dsn)
    end

    def dump!(source_dsn)
      puts '=== Lokka DataMapper Dump ==='
      puts "Source: #{source_dsn}"
      puts

      source_config = parse_source_dsn(source_dsn)
      ActiveRecord::Base.establish_connection(source_config)

      tables = ActiveRecord::Base.connection.tables
      puts "Source tables found: #{tables.join(', ')}"
      puts

      data = {}
      TABLES_IN_ORDER.each do |table|
        if tables.include?(table)
          rows = read_table(table)
          data[table] = rows
          puts "  ✓ #{table}: #{rows.size} records"
        else
          puts "  ⚠ Table '#{table}' not found in source, skipping"
          data[table] = []
        end
      end

      File.write(DUMP_FILE, JSON.pretty_generate(data))
      puts
      puts "Dump written to #{DUMP_FILE}"
      puts "Total: #{data.values.sum(&:size)} records dumped"
    end

    # --- Import phase (new environment) ---

    def self.import!
      new.import!
    end

    def import!
      puts '=== Lokka DataMapper Import ==='
      puts "Reading #{DUMP_FILE}"
      puts

      unless File.exist?(DUMP_FILE)
        puts "ERROR: #{DUMP_FILE} not found."
        puts "Run 'rake db:dump_dm SOURCE=...' on the old environment first."
        exit 1
      end

      data = JSON.parse(File.read(DUMP_FILE))
      conn = ActiveRecord::Base.connection
      target_tables = conn.tables
      counts = {}

      TABLES_IN_ORDER.each do |table|
        rows = data[table] || []
        if rows.empty?
          counts[table] = 0
          next
        end

        unless target_tables.include?(table)
          puts "  ⚠ Target table '#{table}' doesn't exist, skipping"
          counts[table] = 0
          next
        end

        count = import_table(conn, table, rows)
        counts[table] = count
        puts "  ✓ #{table}: #{count} records"
      end

      reset_sequences!(conn)

      puts
      puts '=== Import Complete ==='
      counts.each {|t, c| puts "  #{t}: #{c} records" }
      puts
      puts "Total: #{counts.values.sum} records imported"
    end

    private

    def read_table(table)
      conn = ActiveRecord::Base.connection
      conn.select_all("SELECT * FROM #{conn.quote_table_name(table)}").to_a
    end

    def import_table(conn, table, rows)
      target_columns = conn.columns(table).map(&:name)
      skip_cols = SKIP_COLUMNS[table] || []

      count = 0
      rows.each do |row|
        filtered = row.select {|k, _v| target_columns.include?(k) && !skip_cols.include?(k) }
        next if filtered.empty?

        columns = filtered.keys
        values = filtered.values

        placeholders = values.map { '?' }.join(', ')
        quoted_columns = columns.map {|c| conn.quote_column_name(c) }.join(', ')

        sql = "INSERT INTO #{conn.quote_table_name(table)} (#{quoted_columns}) VALUES (#{placeholders})"

        begin
          conn.exec_insert(sql, "#{table} INSERT", values.map.with_index do |v, i|
            ActiveRecord::Relation::QueryAttribute.new(columns[i], v, ActiveRecord::Type::Value.new)
          end)
          count += 1
        rescue ActiveRecord::RecordNotUnique => e
          puts "  ⚠ Duplicate in #{table}, skipping: #{e.message.truncate(80)}"
        rescue StandardError => e
          puts "  ✗ Error in #{table}: #{e.message.truncate(120)}"
        end
      end

      count
    end

    def reset_sequences!(conn)
      return unless conn.adapter_name =~ /PostgreSQL/i

      puts
      puts 'Resetting PostgreSQL sequences...'
      TABLES_IN_ORDER.each do |table|
        next if table == 'options'
        next unless conn.tables.include?(table)

        begin
          max_id = conn.select_value("SELECT MAX(id) FROM #{conn.quote_table_name(table)}")
          conn.execute("SELECT setval(pg_get_serial_sequence('#{table}', 'id'), #{max_id})") if max_id
        rescue StandardError
          # Table might not have an id column
        end
      end
    end

    def parse_source_dsn(dsn)
      if dsn =~ %r{\Asqlite3?://}
        path = dsn.sub(%r{\Asqlite3?://}, '')
        { adapter: 'sqlite3', database: path }
      elsif dsn =~ %r{\Apostgres(ql)?://}
        { adapter: 'postgresql', url: dsn }
      elsif dsn =~ %r{\Amysql2?://}
        { adapter: 'mysql2', url: dsn }
      elsif File.exist?(dsn)
        { adapter: 'sqlite3', database: File.expand_path(dsn) }
      else
        raise "Unknown source DSN format: #{dsn}. Use sqlite3://path, postgres://..., mysql://..., or a file path."
      end
    end
  end
end
