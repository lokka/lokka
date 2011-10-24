module Lokka
  module Plugin
    module Loader
      def self.registered(app)
        names = []
        Dir["#{Lokka.root}/public/plugin/lokka-*/lib/lokka/*.rb"].each do |path|
          path = Pathname.new(path)
          lib = path.parent.parent
          root = lib.parent
          $:.push lib
          i18n = File.join(root, 'i18n')
          R18n.extension_places << R18n::Loader::YAML.new(i18n) if File.exist? i18n
          name = path.basename.to_s.split('.').first
          require "lokka/#{name}"
          begin
            plugee = ::Lokka.const_get(name.camelize)
            app.register plugee
            names << name
          rescue => e
            puts "plugin #{root} is identified as a suspect."
            puts e
          end
        end
  
        plugins = []
        unless app.routes['GET'].blank?
          matchers = app.routes['GET'].map(&:first)
          names.map do |name|
            plugins << OpenStruct.new(
              :name => name,
              :have_admin_page => matchers.any? {|m| m =~ "/admin/plugins/#{name}" })
          end
        end
        app.set :plugins, plugins
      end
    end
  end
end
