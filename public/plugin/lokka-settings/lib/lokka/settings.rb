# -- coding: utf-8

require "settingslogic"

class Settings < Settingslogic
  source File.join(Lokka.root, "application.yml")
  namespace Lokka.env
end
