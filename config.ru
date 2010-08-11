$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

require '.bundle/environment'
require 'pyha'

run Pyha::App
