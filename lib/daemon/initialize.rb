module IMP
  class Daemon

    def initialize config
      socket = TCPServer.new(PORT)
      fork do
        @serv = socket
        Signal.trap("EXIT") { close }
        Process.daemon
        start
      end
      socket.close
    end

    def listener
      loop do
        Thread.new(@serv.accept) do |client|
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
