module Pyha
  module Before
    def self.registered(app)
      app.before do
        @site = Site.first
        @title = @site.title
        @theme = Theme.new(settings.theme)
        @theme_types = []

        session[:locale] = params[:locale] if params[:locale]

        logger.debug "path_info: #{request.path_info}"
      end
    end
  end
end
