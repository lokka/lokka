# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Lokka::EntryPreviewHandler do
  describe '#hamdle' do
    let(:result) do
      described_class.new(params).handle
    end

    context 'With valid params' do
      let(:params) do
        {
          markup: 'redcarpet',
          raw_body: "# a\n\n## b\n\nTest"
        }
      end

      it 'Should respond HTML for body' do
        expect(result[:body]).to eq(
          <<~HTML
            <h1>a</h1>

            <h2>b</h2>

            <p>Test</p>
          HTML
        )
      end

      it 'status should eq 201' do
        expect(result[:status]).to eq(201)
      end
    end

    context 'With unknown markup' do
      let(:params) do
        {
          markup: 'textile',
          raw_body: "# a\n\n## b\n\nTest"
        }
      end

      it 'Should respond as plain text' do
        expect(result[:body]).to eq("# a\n\n## b\n\nTest")
      end
    end

    context 'With blank params' do
      let(:params) do
        {}
      end

      it 'Should respond as plain text' do
        expect(result[:body]).to be_blank
      end
    end
  end
end

describe Lokka::FileUploadHandler do
  before do
    Aws.config[:s3] = { stub_responses: { list_buckets: {} } }
    Aws::S3::Bucket.any_instance.stub(:upload_file).and_return(true)
    Option.aws_access_key_id = 'foo'
    Option.aws_secret_access_key = 'bar'
    Option.s3_region = 'ap-northeast-1'
    Option.s3_bucket_name = 'dummy'
  end

  describe '#handle' do
    let(:result) do
      described_class.new(params).handle
    end

    let(:fixture_path) do
      File.expand_path(File.dirname(__FILE__) + '/../fixtures')
    end

    context 'With valid params' do
      let(:params) do
        { file: { tempfile: Rack::Test::UploadedFile.new(File.join(fixture_path, '1px.gif')) } }
      end

      it 'Should be success' do
        expect(result[:status]).to eq(201)
      end
    end

    context 'With invalid params' do
      let(:params) do
        { foo: 'bar' }
      end

      it 'Should be failure' do
        expect(result[:status]).to eq(400)
      end
    end

    context 'When aws creadentials are not set' do
      before do
        keys = %i[aws_access_key_id aws_secret_access_key s3_region s3_bucket_name]
        Option.where(name: keys).delete_all
      end

      let(:params) do
        { file: { tempfile: Rack::Test::UploadedFile.new(File.join(fixture_path, '1px.gif')) } }
      end

      it 'Should be failure' do
        expect(result[:status]).to eq(400)
      end
    end
  end
end
