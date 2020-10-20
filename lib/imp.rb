# frozen_string_literal: true

require 'socket'
require 'json'
require 'securerandom'

module IMP
  extend self
  @@client = nil

  module Daemon
    extend self
  end

  class Client; end

  private_constant :Daemon, :Client
end

Dir["#{__dir__}/**/*.rb"].each do |rb|
  require_relative rb
end
