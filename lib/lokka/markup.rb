module Markup
  class << self
    attr_accessor :engine_list

    def name_description_pair_list
      @engine_list.dup.unshift ['', 'default HTML']
    end

    def use_engine(name, text)
      @engine_list.each do |engine|
        return engine[2].call(text) if engine[0] == name
      end
      text
    end
  end

  @engine_list = [
      ['kramdown', 'Markdown (Kramdown)',
        lambda{ |text| Kramdown::Document.new(text).to_html }],
      ['redcloth', 'Textile (Redcloth)',
        lambda{ |text| RedCloth.new(text).to_html }],
      ['wikicloth', 'MediaWiki (WikiCloth)',
        lambda{ |text| WikiCloth::Parser.new(:data => text).to_html(:noedit => true) }]
  ]
end
