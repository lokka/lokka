require 'stringex'

module Rack
  module Utils
    alias :escape_org :escape
    alias :unescape_org :unescape

    def escape(s)
      escape_org(s).force_encoding(Encoding.default_external)
    end
    def unescape(s)
      unescape_org(s).force_encoding(Encoding.default_external)
    end
  end
end

module DataMapper
  module Validations
    class LengthValidator
      alias :value_length_org :value_length
      def value_length(value)
        value.force_encoding(Encoding.default_external)
        value_length_org(value)
      end
    end
  end
end

module Stringex
  module StringExtensions
    alias :to_url_org :to_url
    def to_url
      self.force_encoding(Encoding.default_external)
    end
  end
end

module Tilt
  class Template
    alias :render_org :render
    def render(scope=Object.new, locals={}, &block)
      output = render_org(scope, locals, &block)
      output.force_encoding(Encoding.default_external) unless output.nil?
    end
  end
end
