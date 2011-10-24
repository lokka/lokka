# encoding: utf-8
require 'rubygems'
require 'pathname'
require 'erb'
require 'ostruct'
require 'digest/sha1'
require 'csv'

require 'active_support/all'
require 'sinatra/base'
require 'sinatra/reloader'
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
require 'nokogiri'
if RUBY_VERSION >= '1.9'
  require 'ruby19'
else
  require 'ruby18'
end

require 'lokka/database'
require 'lokka/theme'
require 'lokka/user'
require 'lokka/site'
require 'lokka/option'
require 'lokka/entry'
require 'lokka/category'
require 'lokka/comment'
require 'lokka/snippet'
require 'lokka/tag'
require 'lokka/plugin/loader'

module Lokka
  autoload :Before, 'lokka/before'
  autoload :Helpers, 'lokka/helpers'
  autoload :App, 'lokka/app'
  autoload :Importer, 'lokka/importer'

  class NoTemplateError < StandardError; end
  MODELS = [Site, Option, User, Entry, Category, Comment, Snippet, Tag, Tagging]

  def self.root
    File.expand_path('..', File.dirname(__FILE__))
  end

  def self.dsn
    filename = File.exist?("#{Lokka.root}/database.yml") ? 'database.yml' : 'database.default.yml'
    YAML.load(ERB.new(File.read("#{Lokka.root}/#{filename}")).result(binding))[self.env]['dsn']
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
end
