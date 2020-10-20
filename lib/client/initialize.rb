module IMP

  class Client
    def initialize
      @sock = TCPSocket.new('localhost', PORT)

      # identification
      buff = JSON.parse(@sock.gets)
      raise if buff['imp'].nil?

      # Ensure the message received uses the current IMP version
      raise IMP::Errors::IncompatibleVersion, buff[:version] unless buff[:version] == IMP::VERSION

      # now just receive responses
      @requests = Hash.new
      Thread.new do
        listener
      end
    end
  end

end
