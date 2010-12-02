module Lokka
  module NewRelicRpm
    def self.registered(app)
      app.configure :production do
        require 'newrelic_rpm'
      end
    end
  end
end
