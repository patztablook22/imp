require 'socket'

module IMP

  extend self

  PORT = 12345
  @@client = nil

  class Daemon
  end
  class Client
  end

  private_constant :Daemon, :Client

end

Dir["#{__dir__}/**/*.rb"].each do |rb|
  require_relative rb
end
