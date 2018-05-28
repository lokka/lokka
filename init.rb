# frozen_string_literal: true

$LOAD_PATH.unshift File.dirname(__FILE__)
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')

require 'rubygems'
require 'bundler'
Bundler.setup
require 'lokka'
I18n.reload!
