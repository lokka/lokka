# frozen_string_literal: true

module Markup
  class << self
    attr_accessor :engine_list

    def use_engine(name, text)
      @engine_list.each do |engine|
        return engine[2].call(text) if engine[0] == name
      end
      text.html_safe
    end
  end

  @engine_list = [
    ['html', 'HTML', ->(text) { text }],
    ['kramdown', 'Markdown (Kramdown)',
     lambda do |text|
       Kramdown::Document.new(text,
         coderay_line_numbers: nil,
         coderay_css: :class).to_html
     end],
    ['redcloth', 'Textile (Redcloth)',
     ->(text) { RedCloth.new(text).to_html }],
    ['redcarpet', 'Markdown (redcarpet)',
     lambda do |text|
       Redcarpet::Markdown.new(
         Redcarpet::Render::HTML,
         no_intra_emphasis: true,
         fenced_code_blocks: true,
         autolink: true,
         tables: true,
         superscript: true,
         space_after_headers: true
       ).render(text)
     end]
  ]
end
