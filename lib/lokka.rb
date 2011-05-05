require 'rubygems'
require 'pathname'
require 'erb'
require 'ostruct'
require 'digest/sha1'
require 'csv'

require 'active_support/all'
require 'sinatra/base'
require 'sinatra/r18n'
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
require 'sass'
require 'slim'
require 'builder'

autoload :Theme, 'lokka/theme'
autoload :User, 'lokka/user'
autoload :Site, 'lokka/site'
autoload :Option, 'lokka/option'
autoload :Entry, 'lokka/entry'
autoload :Category, 'lokka/category'
autoload :Comment, 'lokka/comment'
autoload :Snippet, 'lokka/snippet'
autoload :Bread, 'lokka/bread'
autoload :BreadCrumb, 'lokka/bread_crumb'

module Lokka
  autoload :Before, 'lokka/before'
  autoload :Helpers, 'lokka/helpers'
  autoload :App, 'lokka/app'

  class NoTemplateError < StandardError; end
  MODELS = [Site, Option, User, Entry, Category, Comment, Snippet, Tag, Tagging]

  def self.root
    File.expand_path('..', File.dirname(__FILE__))
  end

  def self.config
    YAML.load(ERB.new(File.read("#{Lokka.root}/config.yml")).result(binding))
  end

  def self.env
    if ENV['LOKKA_ENV'] == 'production' or ENV['RACK_ENV'] == 'production'
      'production'
    elsif ENV['LOKKA_ENV'] == 'test' or ENV['RACK_ENV'] == 'test'
      'test'
    else
      'development'
    end
  end

  def self.production?
    self.env == 'production'
  end

  def self.development?
    self.env == 'development'
  end

  def self.test?
    self.env == 'test'
  end

  class Database
    def connect
      DataMapper::Logger.new(STDOUT, :debug) if Lokka.development?
      DataMapper.setup(:default, Lokka.config[Lokka.env]['dsn'])
      self
    end

    def load_fixture(name)
      model = name.to_s.classify.constantize
      csv = CSV.read("#{Lokka.root}/db/seed/#{name}.csv")
      headers = csv.shift.map {|i| i.to_s }
      csv.map {|row|
        row.map {|cell| cell.to_s }
      }.map {|row|
        Hash[*headers.zip(row).flatten]
      }.each {|row|
        fields = {}
        row.each do |k, v|
          fields[k] = v if !v.blank?
        end
        model.create!(fields)
      }
    end

    def migrate
      Lokka::MODELS.each {|m| m.auto_upgrade! }
      self
    end

    def migrate!
      Lokka::MODELS.each {|m| m.auto_migrate! }
      self
    end

    def seed
      load_fixture :users
      load_fixture :sites
      load_fixture :entries
    end
  end
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
    UTF_8 = nil
    BINARY = nil
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

Slim::Engine.set_default_options :pretty => true
