# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/admin_helper'

class AdminFileUploadTest < LokkaTestCase
  include AdminLoginContext

  def test_get_admin_file_upload_shows_form
    get '/admin/file_upload'
    assert last_response.ok?
    assert_match '<form', last_response.body
  end

  def test_put_admin_file_upload_with_valid_params_succeeds
    put '/admin/file_upload',
        aws_access_key_id: 'foo',
        aws_secret_access_key: 'bar',
        s3_region: 'ap-northeast-1',
        s3_bucket_name: 'example'
    follow_redirect!
    assert_match I18n.t('file_upload.successfully_updated'), last_response.body
  end

  def test_put_admin_file_upload_with_invalid_params_fails
    put '/admin/file_upload', bar: 'buzz'
    assert_equal 400, last_response.status
  end
end
