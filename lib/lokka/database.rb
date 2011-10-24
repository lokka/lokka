module Lokka
  class Database
    def connect
      DataMapper.finalize
      DataMapper.setup(:default, Lokka.dsn)
      self
    end

    def load_fixture(path, model_name=nil)
      model = model_name || File.basename(path).sub('.csv','').classify.constantize
      headers, *body = CSV.read(path)
      body.each { |row| model.create!(Hash[*(headers.zip(row).reject {|i|i[1].blank?}.flatten)]) }
    end

    def migrate
      Lokka::MODELS.map(&:auto_upgrade!)
      self
    end

    def migrate!
      Lokka::MODELS.map(&:auto_migrate!)
      self
    end

    def seed
      seed_file = File.join(Lokka.root, 'db', 'seeds.rb')
      load(seed_file) if File.exist?(seed_file)
    end
  end
end
