module IMP
  class Daemon

    def stop
      @serv&.close
    end

  end
end
