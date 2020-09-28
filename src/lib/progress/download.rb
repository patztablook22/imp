class Download < Progress

  @source
  @target
  @status
  @whole

  def initialize *data
    data = data[0]
    return unless data.class == Hash and data.size == 1
    @source = data.keys[0]
    @target = data.values[0]
  end

  def go!

    return unless @source and @target

    buf = File.new(@target, 'w')
    url = URI(@source)

    Net::HTTP.start(url.hostname) do |http|

      head = http.request_head url
      uri  = URI.parse(@source)
      buf << uri.open.read

    rescue
      raise "404"
    end

    return true

  end

end
