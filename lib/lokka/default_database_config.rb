module Lokka
  class Database
    DefaultConfig = {
      'production' => {'dsn' => ENV['DATABASE_URL']},
      'development' => {'dsn' => "sqlite3://#{Lokka.root}/db/development.sqlite3"},
      'test' => {'dsn' => "sqlite3://#{Lokka.root}/db/test.sqlite3"}
    }
  end
end
