module IMP
  module Daemon

    def stop
      @@server&.close
    end

  end
end
