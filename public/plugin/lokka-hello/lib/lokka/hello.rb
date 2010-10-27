module Lokka
  module Hello
    def self.registered(app)
      app.get '/hello' do
        'hello'
      end
    end
  end

  module Helpers
    def hello
      'hello'
    end
  end
end
