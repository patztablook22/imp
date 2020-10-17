module IMP
  class Client

    def initialize

      @sock = TCPSocket.new('localhost', PORT)

      # initial ping
      @sock.gets

      # now just receive responses
      Thread.new do
        listener
      end

    end

    def listener

      @requests = Hash.new

      loop do
        response
      rescue IOError
        close
        break
      rescue
      end

    end

  end
end
