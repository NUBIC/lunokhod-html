require 'capybara/cucumber'
require 'rspec'

$LOAD_PATH.unshift File.expand_path('../../../lib', __FILE__)

require 'lunokhod/html'

Capybara.default_driver = :selenium
