module IMP
  class Daemon
    class Handler

      @@all = Array.new

      def initialize socket

        @sock = socket
        @port = nil
        @user = nil

        @sock.puts Time.now.ctime
        input = @sock.gets

        case input
        when "stop\n"
          @sock.puts "closing!"
          exit
        when nil
          close
        else
        end

      end

    end
  end
end
