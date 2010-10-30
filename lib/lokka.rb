# coding: utf-8
require 'rubygems'
require 'pathname'
require 'erb'
require 'ostruct'
require 'digest/sha1'

require 'active_support/all'
require 'sinatra/base'
require 'sinatra/r18n'
require 'sinatra/logger'
require 'sinatra/content_for'
require 'rack/flash'
require 'dm-core'
require 'dm-timestamps'
require 'dm-migrations'
require 'dm-validations'
require 'dm-types'
require 'dm-is-tree'
require 'dm-tags'
require 'dm-pager'
require 'haml'
require 'builder'
require 'exceptional'

require 'lokka/theme'
require 'lokka/user'
require 'lokka/site'
require 'lokka/option'
require 'lokka/entry'
require 'lokka/category'
require 'lokka/tag'
require 'lokka/comment'
require 'lokka/bread_crumb'
require 'lokka/before'
require 'lokka/helpers'
require 'lokka/app'

module Lokka
  class NoTemplateError < StandardError; end
end

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
    def self.default_external
      nil
    end
  end
end

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

module LuckySneaks
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
