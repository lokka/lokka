# frozen_string_literal: true

module Lokka
  module Hello
    def self.registered(app)
      app.get '/hello' do
        'hello'
      end
    end
  end
end
