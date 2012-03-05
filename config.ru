$: << File.dirname(__FILE__) + '/lib'

Bundler.require(:default)

require 'slapme'
require 'slapme/server'

run Slapme::Server.new