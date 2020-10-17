module IMP
  class Daemon

    def initialize

      @socket = TCPServer.new(PORT)
      listener

    end

    def listener
      loop do
        Thread.start(@socket.accept) do |client|
          handler(client)
        end
      end
    end

    def handler client
      client.puts Time.now.ctime
      input = client.gets
      pp input
      case input
      when "stop\n"
        @socket.close
      when nil
        client.close
      else
      end
    end

  end
end
