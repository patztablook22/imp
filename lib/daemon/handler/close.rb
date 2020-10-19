module IMP
  module Daemon
    class Handler

      def close
        @sock&.close
      end

    end
  end
end
