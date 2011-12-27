$:.unshift File.expand_path(File.join(File.dirname(__FILE__), 'lib'))

require 'sinatra/base'
require 'dm-core'
require 'dm-types'
require 'dm-migrations'
require 'dm-timestamps'
require 'dm-validations'
require 'lokka/redirectors'

module Lokka
  class App < Sinatra::Base
    configure do
      set :root, File.expand_path('../../../../', __FILE__)
      set :config => YAML.load(ERB.new(File.read("#{root}/database.default.yml")).result(binding))
    end

    configure :production do
      DataMapper.setup(:default, ENV['DATABASE_URL'] || config['production']['dsn'])
    end

    configure :development do
      DataMapper.setup(:default, config['development']['dsn'])
    end
  end
end
