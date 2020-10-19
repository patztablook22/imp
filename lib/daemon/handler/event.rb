module IMP
  module Daemon
    class Handler

      def self.event name, &block
        define_method("event_#{name}", block)
      end

      event 'ping' do |args|
        args
      end

      event 'stop' do
        Daemon.stop
        exit
      end

    end
  end
end
