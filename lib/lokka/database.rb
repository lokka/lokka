# frozen_string_literal: true

require 'logger'

module Lokka
  module Database
    def self.connect
      ActiveRecord::Base.logger = Logger.new(STDERR) if Lokka.env == 'development'
      ActiveRecord::Base.establish_connection(Lokka.dsn)
    end
  end

  module Migrator
    def self.migrate!
      Database.connect

      migration_path = File.join(Lokka.root, 'db', 'migration')
      ActiveRecord::Migrator.migrate(migration_path)

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
