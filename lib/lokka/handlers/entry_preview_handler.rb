# frozen_string_literal: true

module Lokka
  class EntryPreviewHandler
    attr_reader :params, :default_markup

    def initialize(params, default_markup = 'html')
      @params = params
      @default_markup = default_markup
    end

    def handle
      {
        message: 'Preview successfull',
        body: body,
        markup: markup,
        status: 201
      }
    rescue StandardError => e
      {
        message: e.message,
        status: 500
      }
    end

    private

    def markup
      @markup = params[:markup] || default_markup
    end

    def raw_body
      @raw_body = params[:raw_body] || ''
    end

    def body
      @body ||= Markup.use_engine(markup, raw_body)
    end
  end
end
