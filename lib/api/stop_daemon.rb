module IMP
  def stop_daemon

    if @@client.nil? and open == false
      # no daemon running
      return
    end
    
    case @@client.request('stop', nil)
    when NilClass
      # not thoroughly implemented yet
      # nil is automatically assigned to all requests when disconnected
      @@client = nil
      true
    else
      # not thoroughly implemented yet
      # e.g. permissions
      false
    end

  end
end
