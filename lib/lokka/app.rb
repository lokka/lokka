# frozen_string_literal: true

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
      set public_folder: proc { File.join(root, 'public') }
      set views: proc { public_folder }
      set theme: proc { File.join(public_folder, 'theme') }
      set supported_templates: %w[erb haml :slim erubis]
      set supported_stylesheet_templates: %w[scss sass]
      set supported_javascript_templates: %w[coffee]
      set :scss, Compass.sass_engine_options
      set :sass, Compass.sass_engine_options
      set :per_page, 10
      set :admin_per_page, 200
      set :default_locale, 'en'
      set :haml, attr_wrapper: '"'
      set :session_secret, 'development' if development?
      set :protect_from_csrf, true
      supported_stylesheet_templates.each do |style|
        set style, style: :expanded
      end
      ::I18n.load_path += Dir["#{root}/i18n/*.yml"]
      helpers Lokka::Helpers
      helpers Lokka::PermalinkHelper
      helpers Lokka::RenderHelper
      helpers Kaminari::Helpers::SinatraHelpers
      use Rack::Session::Cookie, {
        expire_after: 60 * 60 * 24 * 12,
        secret: SecureRandom.hex(30)
      }
      use RequestStore::Middleware
      register Sinatra::Flash
      register Padrino::Helpers
      register Sinatra::Namespace
      Lokka.load_plugin(self)
      Lokka::Database.connect
    end

    require 'lokka/app/admin.rb'
    %w[categories comments entries field_names snippets tags themes users file_upload].each do |f|
      require "lokka/app/admin/#{f}"
    end
    require 'lokka/app/entries.rb'

    not_found do
      if custom_permalink?
        return redirect(request.path.sub(%r{/$}, '')) if %r{/$} =~ request.path

        correct_path = custom_permalink_fix(request.path)
        return redirect(correct_path) if correct_path

        @entry = custom_permalink_entry(request.path)
        status 200
        return setup_and_render_entry if @entry

        status 404
      end

      render404 = render_any('404', layout: false)
      return render404 if render404

      haml :"404", views: 'public/lokka', layout: false
    end

    error do
      'Error: ' + env['sinatra.error'].name
    end

    get '/*.css' do |path|
      content_type 'text/css', charset: 'utf-8'
      render_any path.to_sym, views: settings.views
    end

    get '/*.js' do |path|
      content_type 'text/javascript', charset: 'utf-8'
      render_any path.to_sym, views: settings.views
    end

    run! if app_file == $PROGRAM_NAME
  end
end
