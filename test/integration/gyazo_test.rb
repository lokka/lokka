# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../support/admin_helper'

class GyazoTest < LokkaTestCase
  include AdminLoginContext

  def test_get_settings_page
    get '/admin/plugins/gyazo'

    assert last_response.ok?
    assert_includes last_response.body, 'gyazo_access_token'
  end

  def test_settings_page_saves_access_token
    put '/admin/plugins/gyazo', gyazo_access_token: 'token'

    assert last_response.redirect?
    assert_equal 'token', Option.gyazo_access_token
  end

  def test_uploads_image_to_gyazo
    Option.gyazo_access_token = 'token'
    response = Struct.new(:body, :code).new('{"url":"https://i.gyazo.com/image.png"}', '200')
    client = Struct.new(:response) do
      def request(_request)
        response
      end
    end.new(response)
    file = Rack::Test::UploadedFile.new(File.join(fixture_path, '1px.gif'), 'image/gif')

    Net::HTTP.stub(:start, client) do
      post '/admin/attachments', file: file
    end

    assert_equal 201, last_response.status
    assert_equal 'https://i.gyazo.com/image.png', JSON.parse(last_response.body)['url']
  end
end
