module IMP
  class Client

    def responded(uuid, data)
      todo = @requests[uuid]
      Thread.new { todo.call(data) }
      @requests.delete(uuid)
    end

  end
end
