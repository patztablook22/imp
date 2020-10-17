module IMP
  class Client

    def initialize
      @sock = TCPSocket.new("localhost", PORT)
    end

  end
end
