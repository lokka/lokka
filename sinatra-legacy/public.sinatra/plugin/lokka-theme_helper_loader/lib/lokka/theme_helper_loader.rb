# frozen_string_literal: true

module Lokka
  module ThemeHelperLoader
    def self.registered(_app)
      Dir["#{Lokka.root}/public/theme/*/helper/*_helper.rb"].each do |path|
        path = Pathname.new(path)
        lib  = path.parent.parent
        $LOAD_PATH.push lib
        name = path.basename.to_s.split('.').first
        require "helper/#{name}"
      end
    end
  end
end
