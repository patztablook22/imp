module IMP
  module Daemon
    class Handler

      @@all = Array.new

      def initialize socket

        @sock = socket
        @port = nil
        @user = nil

        @sock.puts Time.now.ctime

        # add to connected client list
        @@all << self

        # now just receive requests
        listener

      end

      def listener
        loop do
          respond
        rescue IOError
          @all.delete(self)
          close
          break
        rescue
        end
      end

    end
  end
end
