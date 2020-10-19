module IMP
  def ping *args, &hook
    @@client&.request('ping', args, &hook)
  end
end
