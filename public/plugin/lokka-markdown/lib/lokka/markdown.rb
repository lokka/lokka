require 'bluefeather'

module Lokka
  module Markdown
    include Lokka::Plugin

    class Entry
      def body_html
        BlueFeather.parse(attribute_get(:body))
      end

    end
  end
end
