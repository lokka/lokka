# encoding: utf-8
require 'rubygems'
require 'pathname'
require 'erb'
require 'ostruct'
require 'digest/sha1'
require 'csv'

module Lokka
  class NoTemplateError < StandardError; end

  class << self
    ##
    # Root directory.
    #
    # @return [String] path for lokka application root directory.
    def root
      File.expand_path('..', File.dirname(__FILE__))
    end

    ##
    # Data Source Name
    #
    # @return [String] DSN (Data Source Name) is configuration for database.
    def dsn
      filename = File.exist?("#{Lokka.root}/database.yml") ? 'database.yml' : 'database.default.yml'
      YAML.load(ERB.new(File.read("#{Lokka.root}/#{filename}")).result(binding))[self.env]['dsn']
    end

    ##
    # Current environment.
    #
    # @return [String] `production`, `development` or `test`
    def env
      if ENV['LOKKA_ENV'] == 'production' or ENV['RACK_ENV'] == 'production'
        'production'
      elsif ENV['LOKKA_ENV'] == 'test' or ENV['RACK_ENV'] == 'test'
        'test'
      else
        'development'
      end
    end

    %w(production development test).each do |name|
      define_method("#{name}?") do
        env == name
      end
    end

    def parse_http(str)
      return [] if str.nil?
      locales = str.split(',')
      locales.map! do |locale|
        locale = locale.split ';q='
        if 1 == locale.size
          [locale[0], 1.0]
        else
          [locale[0], locale[1].to_f]
        end
      end
      locales.sort! { |a, b| b[1] <=> a[1] }
      locales.map! { |i| i[0] }
    end

    def load_plugin(app)
      names = []
      Dir["#{Lokka.root}/public/plugin/lokka-*/lib/lokka/*.rb"].each do |path|
        path = Pathname.new(path)
        lib = path.parent.parent
        root = lib.parent
        $:.push lib
        i18n = File.join(root, 'i18n')
        I18n.load_path += Dir["#{i18n}/*.yml"] if File.exist? i18n
        name = path.basename.to_s.split('.').first
        require "lokka/#{name}"
      end

      Lokka.constants.each do |name|
        const = Lokka.const_get(name)
        if const.respond_to? :registered
          app.register const
          names << name.to_s.underscore
        end
      end

      plugins = []
      unless app.routes['GET'].blank?
        matchers = app.routes['GET'].map(&:first)
        names.map do |name|
          plugins << OpenStruct.new(
            :name => name,
            :have_admin_page => matchers.any? {|m| m =~ "/admin/plugins/#{name}" })
        end
      end
      app.set :plugins, plugins
    end
  end
end

require 'active_support/all'
require 'sinatra/base'
require 'sinatra/reloader'
require 'padrino-helpers'
require 'rack/flash'
require 'dm-core'
require 'dm-timestamps'
require 'dm-migrations'
require 'dm-validations'
require 'dm-types'
require 'dm-is-tree'
require 'dm-tags'
require 'dm-pager'
require 'coderay'
require 'kramdown'
require 'redcloth'
require 'wikicloth'
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
if Lokka.development? || Lokka.test?
  require 'tapp'
end
require 'lokka/database'
require 'lokka/theme'
require 'lokka/user'
require 'lokka/site'
require 'lokka/option'
require 'lokka/entry'
require 'lokka/category'
require 'lokka/comment'
require 'lokka/field_name'
require 'lokka/field'
require 'lokka/snippet'
require 'lokka/tag'
require 'lokka/markup'
require 'lokka/importer'
require 'lokka/before'
require 'lokka/helpers'
require 'lokka/app'
