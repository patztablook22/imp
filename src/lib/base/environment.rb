class Environment

  attr_reader :conf, :errs, :aurs, :pkgs, :root, :redo

  @verb
  @conf
  @errs
  @aurs
  @pkgs
  @root
  @todo
  @redo
  @skip
  @keep
  @dump
  @toor
  @find

  def find= bool
    return unless @find.nil?
    @find = bool
  end

  def find?
    @find == true
  end

  def verb= bool
    return unless @verb.nil?
    @verb = bool
  end

  def verb?
    @verb == true
  end

  def skip= pkg
    return if pkg.nil?
    @skip = @skip.to_a + pkg.split(",")
  end

  def skip? pkg
    @skip.to_a.include? pkg or @skip.to_a.include? "ALL"
  end

  def conf= path
    return if @conf or !path or path.empty?
    @conf = File.expand_path path
  end

  def conf!

    return unless @conf
    parser = Parser.new @conf
    data = parser.data
    return unless data

    err = false

    data.each_pair do |key, val|

      assign = key + "="
      val = val[0] if val.class == Array

      begin
        send(assign, val)
      rescue
        Console << "unknown constant: #{key}"
        err = true
      end

    end

    raise if err

  end

  def errs= path
    return if @errs or !path or path.empty?
    @errs = File.expand_path path
  end

  def init!
    [aurs, pkgs, root].each do |path|
      FileUtils.mkdir_p(path) unless File.directory? path
    end
  end

  def aurs= path
    return if @aurs or !path or path.empty?
    @aurs  = File.expand_path path
    @aurs += "/" unless @aurs[-1] == "/"
  end

  def pkgs= path
    return if @pkgs or !path or path.empty?
    @pkgs  = File.expand_path path
    @pkgs += "/" unless @pkgs[-1] == "/"
  end

  def root= path
    return if @root or !path or path.empty?
    @root  = File.expand_path path
    @root += "/" unless @root[-1] == "/"
  end

  def todo= name
    return if name.nil? or name.empty?
    @todo = @todo.to_a << name
  end

  def todo
    return @todo[0] if @todo.to_a.size == 1
    return false
  end

  def redo= bool
    return if @redo
    bool = true? bool
    @redo = bool if @redo.nil?
  end

  def tree?

    dirs = [
      @aurs,
      @pkgs,
      @root,
    ]

    fils = [
      @conf,
      @errs,
    ]

    return dirs.all? { |dir| File.directory? dir } \
    #   && fils.all? { |fil| File.file?      fil }

  end

  def keep= bool
    return unless @keep.nil?
    bool = true? bool
    @keep = bool
  end

  def keep?
    @keep == true
  end

  def toor= bool
    return unless @toor.nil?
    bool = true? bool
    @toor = bool
  end

  def toor?
    @toor == true
  end

  def dump= bool
    return unless @dump.nil?
    bool = true? bool
    @dump = bool
  end

  def dump?
    @dump == true
  end

  def dump!
    return if @keep
    pipe = Pipe.new
    pipe.command = "sudo cp -r #@root. /"
    pipe.go!
    unless pipe.ok?
      exit 1
    end
  end

  def toor!
    Dir["#@root*"].each do |file|
      FileUtils.rm_rf file
    end
  end

  private

  def true? tmp
    tmp.downcase! if tmp.class == String
    case tmp
    when true, "true", -1, 0  ;      true
    when false, "false", 1;          false
    else;                            nil
    end
  end


end

$env = Environment.new
