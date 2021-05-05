# frozen_string_literal: true

require 'logger'

module Lokka
  module Database
    def self.connect
      ActiveRecord::Base.logger = Logger.new(STDERR) if Lokka.development?
      ActiveRecord::Base.logger = Logger.new(File.join(Lokka.root, 'log', 'test.log')) if Lokka.test?
      ActiveRecord::Base.establish_connection(Lokka.dsn)
      ActiveRecord::Base.default_timezone = :local
    end

    def self.delete!
      ActiveRecord::Base.configurations = Lokka.database_config
      ActiveRecord::Tasks::DatabaseTasks.drop_current(Lokka.env)
    end
  end

  module Migrator
    def self.migrate!
      Database.connect

      migration_path = File.join(Lokka.root, 'db', 'migration')
      ActiveRecord::MigrationContext.new(migration_path).migrate

      schema_file = File.join(Lokka.root, 'db', 'schema.rb')
      File.open(schema_file, 'w:utf-8') do |io|
        ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, io)
      end
    end

    def self.seed!
      Database.connect
      seed_file = File.join(Lokka.root, 'db', 'seeds.rb')
      load(seed_file) if File.exist?(seed_file)
    end
  end
end
