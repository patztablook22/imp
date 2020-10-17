module IMP
  class Daemon
    class Handler

      def close
        @sock&.close
      end

    end
  end
end
