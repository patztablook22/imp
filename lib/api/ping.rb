module IMP
  def ping *args, &hook
    @@client&.request(args, &hook)
  end
end
