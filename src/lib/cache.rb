require_relative 'progress/parser'

module Cache

  extend self

  @@data = nil

  def to_s
    "#$git/.cache"
  end

  def [] key = nil
    get if @@data.nil?
    val =  @@data[key]
    if val.class == Array
      val[0]
    else
      val
    end
  end

  def []= key, val
    get if @@data.nil?
    return if @@data[key] == val
    @@data[key] = val
    @@data.compact!
    set
  end

  private

  def get
    @@data = Hash.new
    file   = File.new(to_s) rescue return
    parser = Parser.new file
    @@data = parser.data
  end

  def set

    file   = File.new(to_s, "w")

    @@data.each do |key, val|
      val = val[0] if val.class == Array and val.size == 1
      file << key << " = " << val << "\n"
    end

    file.close

  end

end
