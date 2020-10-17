module IMP
  class Daemon

    def initialize config

      socket = TCPServer.new(PORT)

      fork do

        @serv = socket
        Signal.trap("EXIT") { close }

        Process.daemon

        listener

      end

      socket.close

    end

    def listener
      loop do
        Thread.start(@serv.accept) do |client|
          Handler.new(client)
        end
      rescue IOError
        puts "error"
        exit
      end
    end

  end
end
