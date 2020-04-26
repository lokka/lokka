# frozen_string_literal: true

module Lokka
  class App
    namespace '/admin' do
      get '/file_upload' do
        @aws_access_key_id     = Option.aws_access_key_id
        @aws_secret_access_key = Option.aws_secret_access_key
        @s3_region             = Option.s3_region
        @s3_bucket_name        = Option.s3_bucket_name
        @s3_domain_name        = Option.s3_domain_name
        haml :'admin/file_upload', layout: :'admin/layout'
      end

      put '/file_upload' do
        errors = []

        required_params = %i[aws_access_key_id aws_secret_access_key s3_region s3_bucket_name]
        optional_params = %i[s3_domain_name]
        required_params.each do |key|
          errors << t("file_upload.error.no_#{key}") if params[key].blank?
        end

        if errors.empty?
          required_params.each do |key|
            Option.send("#{key}=", params[key])
          end
          optional_params.each do |key|
            Option.send("#{key}=", params[key])
          end
          flash[:notice] = t('file_upload.successfully_updated')
          redirect to('/admin/file_upload')
        else
          error_message = (['<ul>'] + errors.map {|e| "<li>#{e}</li>" } + ['</ul>']).join("\n")
          flash.now[:error] = error_message
          status 400
          haml :'admin/file_upload', layout: :'admin/layout'
        end
      end

      # attachments
      post '/attachments' do
        result = FileUploadHandler.new(params, request.scheme).handle
        content_type :json
        status result[:status]
        result.to_json
      end
    end
  end
end
