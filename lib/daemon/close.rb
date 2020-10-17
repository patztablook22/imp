module IMP
  class Daemon

    def close
      @serv&.close
    end

  end
end
