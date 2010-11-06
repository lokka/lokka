module Lokka
  module Plugin
    def self.included(mod)
      mod.module_eval do
        @@page = false
        def self.page; @@page end
        def self.page=(value); @@page = value end
        def self.have_page; @@page = true end
      end
    end
  end
end
