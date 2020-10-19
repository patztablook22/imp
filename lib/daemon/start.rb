module IMP
  module Daemon

    @@server = nil

    def start config
      socket = TCPServer.new(PORT)
      fork do
        @@server = socket
        Signal.trap("EXIT") { close }
        Process.daemon
        listener
      end
      socket.close
    end

    def listener
      loop do
        Thread.new(@@server.accept) do |client|
          Handler.new(client)
        end
      rescue IOError
        close
        Handler.each do |hand|
          hand.close
        end
        break
      end
    end

  end
end
