# coding: utf-8
require 'rubygems'
require 'pathname'
require 'erb'
require 'ostruct'
require 'digest/sha1'

require 'active_support/all'
require 'rack-flash'
require 'sinatra/base'
require 'sinatra/r18n'
require 'sinatra/logger'
require 'sinatra/content_for'
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
    def escape(s)
      s.to_s.gsub(/([^ a-zA-Z0-9_.-]+)/n) {
        '%'+$1.unpack('H2'*bytesize($1)).join('%').upcase
      }.tr(' ', '+')
      s.force_encoding(Encoding.default_external)
    end
    def unescape(s)
      s.tr('+', ' ').gsub(/((?:%[0-9a-fA-F]{2})+)/n){
        [$1.delete('%')].pack('H*')
      }
      s.force_encoding(Encoding.default_external)
    end
  end
end

module DataMapper
  module Validations
    class LengthValidator < GenericValidator
      def value_length(value)
        value.force_encoding(Encoding.default_external)
        value.to_str.split(//u).size
      end
    end
  end
end

