module IMP
  class Client

    def close
      @sock&.close
      @sock = nil
    end
  
  end
end
