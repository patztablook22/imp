module IMP
  module Daemon
    class Handler

      def respond

        buff = @sock.gets
        buff = JSON.parse(buff)

        uuid = buff['uuid']
        data = buff['data']

        Daemon.request

        buff = {
          'uuid' => uuid,
          'data' => data,
        }

        @sock.puts buff.to_json

      end

    end
  end
end
