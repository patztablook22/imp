module IMP
  class Client

    def response

      buff = @sock.gets
      buff = JSON.parse(buff)

      uuid = buff['uuid']
      data = buff['data']
      todo = @requests[uuid]

      Thread.new { todo.call(data) }
      @requests.delete(uuid)

    end

  end
end
