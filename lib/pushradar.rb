require 'uri'
require 'forwardable'

require_relative 'pushradar/client'

module PushRadar
  class Error < RuntimeError; end
end

require_relative 'pushradar/version'