require_relative 'progress/parser'

module Config

  extend self

  def to_s
    "#$git/config.txt"
  end

  def parse
    file = File.new(to_s) rescue return
    parser = Parser.new file
    parser.data
  end

end
