module Lokka
  module ThemeHelperLoader
    def self.registered(app)
      Dir["#{Lokka.root}/public/theme/*/helper/*_helper.rb"].each do |path|
        path = Pathname.new(path)
        lib  = path.parent.parent
        root = lib.parent
        $:.push lib
        name = path.basename.to_s.split('.').first
        require "helper/#{name}"
      end
    end
  end
end
