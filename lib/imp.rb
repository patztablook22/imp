require 'socket'

module IMP

  extend self

  PORT = 12345
  @@socket = nil

  class Daemon
    @@instance = nil
  end

  private_constant :Daemon

end

Dir["#{__dir__}/**/*"].each do |rb|
  next unless File.file? rb
  require_relative rb
end
