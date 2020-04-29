require 'lokka'

module Lokka
  class App < Sinatra::Base
    include Padrino::Helpers::TranslationHelpers

    configure :development do
      register Sinatra::Reloader
    end

    configure do
      enable :method_override, :raise_errors, :static, :sessions
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
      set :session_secret, 'development' if development?
      supported_stylesheet_templates.each do |style|
        set style, :style => :expanded
      end
      ::I18n.load_path += Dir["#{root}/i18n/*.yml"]
      helpers Lokka::Helpers
      helpers Lokka::RenderHelper
      helpers Kaminari::Helpers::SinatraHelpers
      use Rack::Session::Cookie, {
        expire_after: 60 * 60 * 24 * 12,
        secret: SecureRandom.hex(30)
      }
      register Sinatra::Flash
      register Padrino::Helpers
      register Sinatra::Namespace
      Lokka.load_plugin(self)
      Lokka::Database.connect
    end

    require 'lokka/app/admin.rb'
    %w[categories comments entries field_names snippets tags themes users].each do |f|
      require "lokka/app/admin/#{f}"
    end
    require 'lokka/app/entries.rb'

    not_found do
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
      render_any path.to_sym, :views => settings.views
    end

    run! if app_file == $0
  end
end
