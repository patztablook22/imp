# frozen_string_literal: true

module IMP
  def open
    return unless @client.nil?

    begin
      @client = Client.new
      true
    rescue StandardError
      false
    end
  end

  def close
    return if @client.nil?

    @client.close
    @client = nil
    true
  end
end
