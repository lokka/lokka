module Lokka
  module Before
    def self.registered(app)
      app.before do
        begin
          Site.first
        rescue DataObjects::SyntaxError
          Lokka::Database.new.create.setup
        end
      end

      app.before do
        @site = Site.first
        @title = @site.title
        @theme = Theme.new(settings.theme)
        @theme_types = []
        session[:locale] = params[:locale] if params[:locale]
      end

      app.before %r{(?!^/admin/login$)^/admin/.*$} do
        login_required
      end
    end
  end
end
