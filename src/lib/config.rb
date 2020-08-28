require_relative 'parser'

module Config

  def self.to_s
    "#$git/config.txt"
  end

  def self.parse
    parser = Parser.new to_s
    return parser.data
  end

end
