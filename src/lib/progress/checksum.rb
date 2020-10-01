# frozen_string_literal: true
module Checksum

  private

  class FUNC < Progress

    @file
    @buff
    @hash
    @func

    def initialize *data
      data = data[0]
      return unless data.class == Hash and data.size == 1
      @file = data.keys[0]
      @buff = String.new
      @hash = data.values[1]
      @func = Digest#::FUNC
      @head = 'checksum'
      @body = @file
    end
    
    def go!
      file  = File.read @file rescue raise 'unreadable file'
      @buff = @func.hexdigest file
    end

    def ok?
      @buff == @hash
    end

  end

  public

  class SHA128 < FUNC
    def initialize data
      super
      @func = Digest::SHA128
    end
  end

  class SHA256 < FUNC
    def initialize data
      super
      @func = Digest::SHA256
    end
  end

  class SHA512 < FUNC
    def initialize data
      super
      @func = Digest::SHA512
    end
  end

  class MD5 < FUNC
    def initialize data
      super
      @func = Digest::MD5
    end
  end

end
