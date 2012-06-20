# encoding: utf-8
require 'lokka'

module Lokka
  class App < Sinatra::Base
    include Padrino::Helpers::TranslationHelpers

    configure :development do
      register Sinatra::Reloader
    end

    configure do
      enable :method_override, :raise_errors, :static, :sessions
      YAML::ENGINE.yamler = 'syck' if YAML.const_defined?(:ENGINE)
      register Padrino::Helpers
      set :app_file, __FILE__
      set :root, File.expand_path('../../..', __FILE__)
      set :public_folder => Proc.new { File.join(root, 'public') }
      set :views => Proc.new { public_folder }
      set :theme => Proc.new { File.join(public_folder, 'theme') }
      set :supported_templates => %w(erb haml slim erubis)
      set :supported_stylesheet_templates => %w(scss sass)
      set :scss, Compass.sass_engine_options
      set :sass, Compass.sass_engine_options
      set :per_page, 10
      set :admin_per_page, 200
      set :default_locale, 'en'
      set :haml, :ugly => false, :attr_wrapper => '"'
      supported_stylesheet_templates.each do |style|
        set style, :style => :expanded
      end
      ::I18n.load_path += Dir["#{root}/i18n/*.yml"]
      helpers Lokka::Helpers
      use Rack::Session::Cookie,
        :expire_after => 60 * 60 * 24 * 12
      set :session_secret, 'development' if development?
      use Rack::Flash
      Lokka.load_plugin(self)
      Lokka::Database.new.connect
    end

    require 'lokka/app/admin.rb'
    require 'lokka/app/entries.rb'

    not_found do
      if custom_permalink?
        if /\/$/ =~ request.path
          return redirect(request.path.sub(/\/$/,""))
        elsif correct_path = custom_permalink_fix(request.path)
          return redirect(correct_path)
        elsif @entry = custom_permalink_entry(request.path)
          status 200
          return setup_and_render_entry
        end
      end

      if output = render_any(:'404', :layout => false)
        output
      else
        haml :'404', :views => 'public/lokka', :layout => false
      end
    end

    error do
      'Error: ' + env['sinatra.error'].name
    end

    get '/*.css' do |path|
      content_type 'text/css', :charset => 'utf-8'
      render_any path.to_sym
    end

    run! if app_file == $0
  end
end
