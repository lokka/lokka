# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe '/admin/attachments' do
  include_context 'admin login'

  describe 'PUT /admin/attachments' do
    context 'With valid params' do
      before do
        Aws.config[:s3] = {
          stub_responses: {
            list_buckets: {}
          }
        }
        Aws::S3::Bucket.any_instance.stub(:upload_file).and_return(true)
        Option.aws_access_key_id = 'foo'
        Option.aws_secret_access_key = 'bar'
        Option.s3_region = 'ap-northeast-1'
        Option.s3_bucket_name = 'dummy'
      end

      it 'should be success' do
        post '/admin/attachments', file: Rack::Test::UploadedFile.new(File.join(fixture_path, '1px.gif'))
        last_response.status.should eq(201)
      end
    end

    context 'With invalid params (No file)' do
      before do
        Aws.config[:s3] = {
          stub_responses: {
            list_buckets: {}
          }
        }
        Aws::S3::Bucket.any_instance.stub(:upload_file).and_return(true)
        Option.aws_access_key_id = 'foo'
        Option.aws_secret_access_key = 'bar'
        Option.s3_region = 'ap-northeast-1'
        Option.s3_bucket_name = 'dummy'
      end

      it 'should be failure' do
        post '/admin/attachments', foo: 'bar'
        last_response.status.should eq(400)
      end
    end

    context 'Without S3 configuration' do
      it 'should be failure' do
        post '/admin/attachments', file: Rack::Test::UploadedFile.new(File.join(fixture_path, '1px.gif'))
        last_response.status.should eq(500)
      end
    end
  end
end
