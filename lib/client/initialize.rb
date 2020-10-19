module IMP
  class Client

    def initialize

      @sock = TCPSocket.new('localhost', PORT)

      # identification
      # todo separate version error
      buff = JSON.parse(@sock.gets)
      raise if buff['imp'].nil?
      raise if buff['version'] != IMP::VERSION

      # now just receive responses
      @requests = Hash.new
      Thread.new do
        listener
      end

    end

  end
end
