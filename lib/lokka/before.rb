# encoding: utf-8
module Lokka
  module Before
    def self.registered(app)
      app.before do
        @site = Site.first
        @title = @site.title

        theme = request.cookies['theme']
        if params[:theme]
          theme = params[:theme]
          response.set_cookie('theme', params[:theme])
        end

        @theme = Theme.new(
          settings.theme,
          request.script_name,
          theme != 'pc' && request.user_agent =~ /iPhone|Android/
        )

        @theme_types = []
        if @theme.exist_i18n?
          R18n.extension_places.reject! do |i18n|
            i18n.dir.match(@theme.root_dir)
          end
          R18n.extension_places << R18n::Loader::YAML.new(@theme.i18n_dir) if @theme.exist_i18n?
        end
        if params[:locale]
          session[:locale] = params[:locale]
          redirect request.referrer
        end
      end

      app.before %r{(?!^/admin/login$)^/admin/.*$} do
        login_required
      end
    end
  end
end
