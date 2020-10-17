module IMP
  class Daemon
    class Handler

      @@all = Array.new

      def initialize socket

        @socket = socket

        @socket.puts Time.now.ctime
        input = @socket.gets

        case input
        when "stop\n"
          puts "stopped!"
          exit
        when nil
          @socket.close
        else
        end

      end

    end
  end
end
