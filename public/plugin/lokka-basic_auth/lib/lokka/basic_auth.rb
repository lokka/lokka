# frozen_string_literal: true

module Lokka
  module BasicAuth
    def self.registered(app)
      app.before '*' do |path|
        next if path =~ %r{^/admin/.*$}

        username = Option.basic_auth_username
        password = Option.basic_auth_password
        if username.present? && password.present?
          @auth ||= Rack::Auth::Basic::Request.new(request.env)
          unless @auth.provided? && @auth.basic? &&
              @auth.credentials && @auth.credentials == [username, password]
            response['WWW-Authenticate'] = %(Basic realm="HTTP Auth")
            throw(:halt, [401, "Not authorized\n"])
          end
        end
      end

      app.get '/admin/plugins/basic_auth' do
        haml :'plugin/lokka-basic_auth/views/index', layout: :'admin/layout'
      end

      app.post '/admin/plugins/basic_auth' do
        Option.basic_auth_username = params['basic_auth_username']
        Option.basic_auth_password = params['basic_auth_password']
        flash[:notice] = 'Updated.'
        redirect to('/admin/plugins/basic_auth')
      end
    end
  end
end
