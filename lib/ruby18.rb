$KCODE = 'UTF8'

unless String.public_method_defined?(:force_encoding)
  class String
    def force_encoding(encoding)
      self
    end
  end
end

unless String.public_method_defined?(:encoding)
  class String
    def encoding
      self
    end
  end
end

unless defined? Encoding
  class Encoding
    UTF_8 = nil # orz!
    BINARY = nil
    def self.default_external
      nil
    end
  end
end

