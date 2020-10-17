module IMP

  def ping *args, &block
    @@client&.request(args, &block)
  end

end
