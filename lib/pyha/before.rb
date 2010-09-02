module Pyha
  module Before
    def self.registered(app)
      app.before do
        @site = Site.first
        @title = @site.title
        @theme = Theme.new(settings.theme)
        @theme_types = []

        logger.debug "path_info: #{requiest.path_info}"
      end
    end
  end
end
