# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe '/admin/file_upload' do
  include_context 'admin login'

  it 'GET should show form for custom permalink' do
    get '/admin/file_upload'
    expect(last_response).to be_ok
    expect(last_response.body).to match('<form')
  end

  describe 'PUT /admin/file_upload' do
    context 'With valid params' do
      it 'should be success' do
        put '/admin/file_upload',           aws_access_key_id: 'foo',
                                            aws_secret_access_key: 'bar',
                                            s3_region: 'ap-northeast-1',
                                            s3_bucket_name: 'example'
        follow_redirect!
        expect(last_response.body).to match(I18n.t('file_upload.successfully_updated'))
      end
    end

    context 'With invalid params' do
      it 'should be failure' do
        put '/admin/file_upload', bar: 'buzz'
        expect(last_response.status).to eq(400)
      end
    end
  end
end
