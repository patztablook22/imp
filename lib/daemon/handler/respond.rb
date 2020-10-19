module IMP
  module Daemon
    class Handler

      def respond

        buff  = @sock.gets
        buff  = JSON.parse(buff)
        event = buff["event"]
        data  = buff['data']

        begin

          func = method("event_#{event}")
          data = case func.arity
                 when 0
                   func.call
                 else
                   func.call(data)
                 end

        rescue => e
          puts e
        end

        pp data
        buff["data"] = data
        @sock.puts buff.to_json

      end

    end
  end
end
