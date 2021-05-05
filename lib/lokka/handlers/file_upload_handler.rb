# frozen_string_literal: true

module Lokka
  class FileUploadHandler
    attr_reader :params, :errors, :request_scheme

    def initialize(params, request_scheme = 'https')
      @params = params
      @errors = []
      @request_scheme = request_scheme
    end

    def handle
      validate_params
      validate_credentials
      return errors.first if errors.present?

      if upload
        {
          message: 'File upload success',
          url: "#{request_scheme}://#{domain_name}/#{filename}",
          status: 201
        }
      else
        {
          message: 'Failed uploading file',
          status: 400
        }
      end
    rescue StandardError => e
      {
        message: e.message,
        status: 500
      }
    end

    def upload
      bucket.object(filename).upload_file(tempfile.path, content_type: content_type)
    end

    private

    def validate_params
      errors << { message: 'No file', status: 400 } if params[:file].blank?
    end

    def validate_credentials
      errors << { message: 'AWS Credentials are not set', status: 400 } unless credentials.set?
    end

    def credentials
      @credentials ||= Aws::Credentials.new(
        Option.aws_access_key_id,
        Option.aws_secret_access_key
      )
    end

    def bucket
      @bucket ||= s3.bucket(Option.s3_bucket_name)
    end

    def s3
      @s3 ||= Aws::S3::Resource.new(region: Option.s3_region, credentials: credentials)
    end

    def domain_name
      @domain_name ||= Option.s3_domain_name.presence || bucket.url
    end

    def digest
      @digest ||= Digest::MD5.file(tempfile.path).to_s
    end

    def tempfile
      @tempfile ||= params[:file][:tempfile]
    end

    def extname
      @extname ||= File.extname(tempfile.path)
    end

    def filename
      @filename ||= digest + extname
    end

    def content_type
      @content_type ||= Marcel::MimeType.for(tempfile)
    end
  end
end
