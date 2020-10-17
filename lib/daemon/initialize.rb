module IMP
  class Daemon

    def initialize

      @socket = TCPServer.new(PORT)
      listener

    end

    def stop
      @socket&.close
    end

    def listener
      loop do
        Thread.start(@socket.accept) do |client|
          Handler.new(client)
        end
      rescue IOError
        break
      end
    end

  end
end
