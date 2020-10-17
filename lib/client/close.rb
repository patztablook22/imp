module IMP
  class Client

    def close
      @sock&.close
    end
  
  end
end
