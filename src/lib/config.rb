require_relative 'parser'

module Config

  def self.to_s
    "#$git/config.txt"
  end

  def self.parse
    file = File.new(to_s) rescue return
    parser = Parser.new file
    return parser.data
  end

end
