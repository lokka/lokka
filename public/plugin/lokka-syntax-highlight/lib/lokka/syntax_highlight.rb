require 'pygments.rb'

module Lokka
  module SyntaxHighlight
    @@engine_list = [
      ['html', 'HTML', lambda{ |text| text }],
      ['kramdown', 'Markdown (Kramdown)',
       lambda do |text|
        Kramdown::Document.new(text,
                               :coderay_line_numbers => nil,
                               :coderay_css => :class
                              ).to_html()
      end
    ],
    ['redcloth', 'Textile (Redcloth)',
     lambda{ |text| RedCloth.new(text).to_html }],
    ['wikicloth', 'MediaWiki (WikiCloth)',
     lambda{ |text| WikiCloth::Parser.new(:data => text).to_html(:noedit => true) }],
    ['redcarpet', 'Markdown (redcarpet)',
     lambda do |text|
      Redcarpet::Markdown.new(
        HTMLwithPygments, # redcarpetのblock_codeの書き方Pygmants対応版にする
        :no_intra_emphasis   => true,
        :fenced_code_blocks  => true,
        :autolink            => true,
        :tables              => true,
        :superscript         => true,
        :space_after_headers => true
      ).render(text)
    end]
    ]

    def self.registered(app)
      app.before do
        content_for :header do
          text = <<-EOS.strip_heredoc
          <link href="/plugin/lokka-syntax-highlight/assets/syntax_highlight.css" rel="stylesheet" type="text/css" />
          EOS
        end

        # Markupのengine_listを上書き
        Markup.instance_variable_set(:@engine_list, @@engine_list)
      end
    end

    # シンタックスハイライトにPygmentsを適用する
    class HTMLwithPygments < Redcarpet::Render::HTML
      def block_code(code, language)
        Pygments.highlight(code, lexer: language)
      end
    end
  end
end
