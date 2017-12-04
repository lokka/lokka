# encoding: utf-8
module Lokka
  module Before
    def self.registered(app)
      app.before do
        @site = RequestStore[:site] ||= Site.first
        @title = @site.title

        locales = Lokka.parse_http(request.env['HTTP_ACCEPT_LANGUAGE'])
        locales.map! do |locale|
          locale =~ /-/ ? locale.split('-').first : locale
        end

        if params[:locale]
          I18n.locale = params[:locale]
          session[:locale] = params[:locale]
          redirect request.referrer
        elsif session[:locale]
          I18n.locale = session[:locale]
        elsif locales.present?
          I18n.locale = locales.first
        end

        theme = request.cookies['theme']
        if params[:theme]
          theme = params[:theme]
          response.set_cookie('theme', params[:theme])
        end

        @theme = RequestStore[:theme] ||= Theme.new(
          settings.theme,
          request.script_name,
          theme != 'pc' && request.user_agent =~ /iPhone|Android/
        )

        @theme_types ||= []
        if @theme.exist_i18n?
          ::I18n.load_path += Dir["#{@theme.i18n_dir}/*.yml"]
        end
      end

      app.before %r{(?!^/admin/login$)^/admin/.*$} do
        login_required
      end
    end
  end
end
