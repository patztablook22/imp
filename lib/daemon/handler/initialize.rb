module IMP
  module Daemon
    class Handler

      @@all = Array.new

      def initialize socket

        @sock = socket
        @port = nil
        @user = nil

        # identification
        @sock.puts({
          'imp'     => 'imp',
          'version' => IMP::VERSION,
        }.to_json)

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
