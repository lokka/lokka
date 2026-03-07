# frozen_string_literal: true

module Lokka
  class Database
    MODELS = %w[site option user entry category comment snippet tag tagging field_name field].freeze

    def connect
      config = Lokka.database_config
      ActiveRecord::Base.establish_connection(config)
      self
    end

    def load_fixture(path, model_name = nil)
      model = model_name || File.basename(path).sub('.csv', '').classify.constantize
      headers, *body = CSV.read(path)
      body.each {|row| model.create!(Hash[*headers.zip(row).reject {|i| i[1].blank? }.flatten]) }
    end

    def migrate
      migration_dir = File.join(Lokka.root, 'db', 'migrate')
      ActiveRecord::Migrator.migrations_paths = [migration_dir]
      ActiveRecord::MigrationContext.new(migration_dir).migrate
      self
    rescue ArgumentError
      # ActiveRecord 8.0+ changed MigrationContext API
      ActiveRecord::MigrationContext.new.migrate
      self
    end

    def migrate!
      # Drop all tables and re-migrate
      ActiveRecord::Base.connection.tables.each do |table|
        ActiveRecord::Base.connection.drop_table(table, if_exists: true)
      end
      migrate
      self
    end

    def seed
      seed_file = File.join(Lokka.root, 'db', 'seeds.rb')
      load(seed_file) if File.exist?(seed_file)
    end
  end
end
