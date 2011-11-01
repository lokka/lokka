module Markup
  def self.name_description_pair_list
    [
      ['', 'default HTML'],
      ['kramdown', 'Markdown (Kramdown)'],
      ['redcloth', 'Textile (Redcloth)']
    ]
  end

  def self.use_engine(name, text)
    case name
    when 'kramdown'
      Kramdown::Document.new(text).to_html
    when 'redcloth'
      RedCloth.new(text).to_html
    else
      text
    end
  end
end
