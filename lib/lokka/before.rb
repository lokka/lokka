module Lokka
  module Before
    def self.registered(app)
      app.before do
        begin
          Site.first
        rescue DataObjects::SyntaxError => e
          Lokka::Database.new.connect.migrate.seed
        end

        @site = Site.first
        @title = @site.title
        @theme = Theme.new(settings.theme)
        @theme_types = []
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
