module IMP
  module Daemon
    class Handler

      def self.each &block
        @@all.each do |hand|
          yield hand
        end
      end

    end
  end
end
