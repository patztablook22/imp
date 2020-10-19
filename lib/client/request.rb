module IMP
  class Client

    def request(event, data, &hook)

      raise if @requests.nil?

      uuid = Random.uuid
      buff = {
        'uuid'  => uuid,
        'event' => event,
        'data'  => data,
      }

      if hook.nil?
        response = :waiting
        hook = Proc.new do |data|
          response = data
        end
      end

      @requests[uuid] = hook
      @sock.puts buff.to_json

      unless block_given?
        while response == :waiting
          sleep 0.1
        end
        return response
      end

    end

  end
end
