# frozen_string_literal: true

require 'json'
require 'net/http'

module Lokka
  module Gyazo
    UPLOAD_URI = URI('https://upload.gyazo.com/api/upload')

    def self.registered(app)
      app.get '/admin/plugins/gyazo' do
        login_required
        erb :'plugin/lokka-gyazo/views/index', layout: :'admin/layout'
      end

      app.put '/admin/plugins/gyazo' do
        login_required
        Option.gyazo_access_token = params[:gyazo_access_token]
        flash[:notice] = 'Updated.'
        redirect to('/admin/plugins/gyazo')
      end

      app.post '/admin/attachments' do
        pass if gyazo_access_token.blank?
        login_required
        content_type :json

        result = upload_to_gyazo(params[:file])
        status result[:status]
        result.to_json
      end
    end
  end

  module Helpers
    def gyazo_access_token
      ENV['GYAZO_ACCESS_TOKEN'].presence || Option.gyazo_access_token
    end

    def upload_to_gyazo(file)
      return { message: 'No image file', status: 400 } unless file&.dig(:type)&.start_with?('image/')

      request = Net::HTTP::Post.new(Gyazo::UPLOAD_URI)
      request['Authorization'] = "Bearer #{gyazo_access_token}"
      request.set_form(
        [['imagedata', file[:tempfile], { filename: file[:filename], content_type: file[:type] }]],
        'multipart/form-data'
      )
      response = Net::HTTP.start(Gyazo::UPLOAD_URI.host, Gyazo::UPLOAD_URI.port, use_ssl: true).request(request)
      body = JSON.parse(response.body)

      unless response.code.start_with?('2')
        return { message: body['message'] || 'Gyazo upload failed', status: response.code.to_i }
      end

      { message: 'File upload success', url: body.fetch('url'), status: 201 }
    rescue JSON::ParserError, KeyError, SocketError, SystemCallError, Timeout::Error => e
      { message: e.message, status: 502 }
    end
  end
end
