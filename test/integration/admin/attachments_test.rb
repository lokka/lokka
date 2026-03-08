# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/admin_helper'

class AdminAttachmentsTest < LokkaTestCase
  include AdminLoginContext

  def setup_s3_stub
    Aws.config[:s3] = {
      stub_responses: {
        list_buckets: {},
        put_object: {}
      }
    }
    Option.aws_access_key_id = 'foo'
    Option.aws_secret_access_key = 'bar'
    Option.s3_region = 'ap-northeast-1'
    Option.s3_bucket_name = 'dummy'
  end

  def test_post_admin_attachments_with_valid_params_succeeds
    setup_s3_stub
    post '/admin/attachments', file: Rack::Test::UploadedFile.new(File.join(fixture_path, '1px.gif'))
    assert_equal 201, last_response.status
  end

  def test_post_admin_attachments_without_file_fails
    setup_s3_stub
    post '/admin/attachments', foo: 'bar'
    assert_equal 400, last_response.status
  end

  def test_post_admin_attachments_without_s3_config_fails
    post '/admin/attachments', file: Rack::Test::UploadedFile.new(File.join(fixture_path, '1px.gif'))
    assert_equal 400, last_response.status
    assert_equal 'AWS Credentials are not set', JSON.parse(last_response.body)['message']
  end
end
