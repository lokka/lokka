require 'pygments.rb'

module Lokka
  module SyntaxHighlight
    SYNTAX_HILIGHT_ENGINE = [
      'redcarpet',
      'Markdown (redcarpet)',
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
      end
    ]

    def self.registered(app)
      app.before do
        content_for :header do
          text = <<-EOS.strip_heredoc
          <link href="/plugin/lokka-syntax-highlight/assets/syntax_highlight.css" rel="stylesheet" type="text/css" />
          EOS
        end

        # engine_list の最後を置き換える
        Markup.engine_list.pop
        Markup.engine_list.push SYNTAX_HILIGHT_ENGINE
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
