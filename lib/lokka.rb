# frozen_string_literal: true

require 'rubygems'
require 'pathname'
require 'erb'
require 'ostruct'
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

    def admin_theme_dir
      File.expand_path("#{root}/public/admin")
    end

    ##
    # Data Source Name
    #
    # @return [Hash] DSN (Data Source Name) is configuration for database.
    def dsn
      filename = File.exist?("#{Lokka.root}/db/database.yml") ? 'database.yml' : 'database.default.yml'
      YAML.load(ERB.new(File.read("#{Lokka.root}/db/#{filename}")).result(binding))[self.env]['database']
    end

    ##
    # Current environment.
    #
    # @return [String] `production`, `development` or `test`
    def env
      if ENV['LOKKA_ENV'] == 'production' || ENV['RACK_ENV'] == 'production'
        'production'
      elsif ENV['LOKKA_ENV'] == 'test' || ENV['RACK_ENV'] == 'test'
        'test'
      else
        'development'
      end
    end

    %w[production development test].each do |name|
      define_method("#{name}?") do
        env == name
      end
    end

    def parse_http(str)
      return [] if str.nil?
      locales = str.split(',')
      locales.map! do |locale|
        locale = locale.split ';q='
        if locale.size == 1
          [locale[0], 1.0]
        else
          [locale[0], locale[1].to_f]
        end
      end
      locales.sort! {|a, b| b[1] <=> a[1] }
      locales.map! {|i| i[0] }
    end

    def load_plugin(app)
      names = []
      Dir["#{Lokka.root}/public/plugin/lokka-*/lib/lokka/*.rb"].each do |path|
        path = Pathname.new(path)
        lib = path.parent.parent
        root = lib.parent
        $LOAD_PATH.push lib
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
            name: name,
            have_admin_page: matchers.any? {|m| m =~ "/admin/plugins/#{name}" }
          )
        end
      end
      app.set :plugins, plugins
    end
  end
end

require 'active_support/all'
require 'active_record'
require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/flash'
require 'sinatra/namespace'
require 'kaminari/activerecord'
require 'kaminari/sinatra'
require 'padrino-helpers'
require 'coderay'
require 'kramdown'
require 'redcloth'
require 'redcarpet'
require 'haml'
require 'sass'
require 'compass'
require 'slim'
require 'coffee-script'
require 'builder'
require 'nokogiri'
require 'request_store'
require 'securerandom'
require 'aws-sdk-s3'
require 'mimemagic'
require 'lokka/helpers/helpers'
require 'lokka/helpers/permalink_helper'
require 'lokka/helpers/render_helper'
require 'lokka/database'
require 'lokka/models'
require 'lokka/importer'
require 'lokka/before'
require 'lokka/app'
require 'lokka/version'
