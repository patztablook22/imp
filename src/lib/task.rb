require_relative 'msg'

class Task

  @@dir = "#$src/task"  # task root
  @@active = nil        # active Task

  @name    # name
  @caller  # called by
  @field   # "local variables"
  @code    # code file
  @status  # return status

  attr_reader :code, :field, :status

  # access active task field
  # getter / setter
  #
  # Task["key"] = 3
  # Task["key"] + 7 == 10
  #
  def self.[]  key
    self.field[key]
  end
  def self.[]= key, val
    self.field[key] = val
  end

  # task message
  #
  # Task> file_updated
  #
  def self.> msg
    puts "│ #{msg}"
    # Msg[1] = msg
  end

  # progress msg
  #
  # Task < percent
  #
  def self.< tmp
    Msg[2] = tmp
  end

  # runs given task
  # field is inherited
  # and assigned "args" => [...]
  #
  # Task* "greet"
  # Task* ["make", "sandwich", :happily]
  #
  def self.*  args
    tmp = Task.new *args
    tmp.status
  end

  # quit task prematurely
  # status:
  #   
  #   0 => success
  #   1 => failure
  #
  # Task^ 0 if actions_needed.nil?
  #
  #
  def self.^ status
    self.quit status
  end

  def initialize *args

    return if args.none?
    name = args.shift

    @name   = name
    @caller = @@active

    if @caller.nil?
      @field = Hash.new
      @code  = "#@@dir/#@name.rb"
    else
      @field = @@active.field
      @code  = File.dirname(@caller.code) + "/#@caller"
      @code  = File.dirname(@caller.code) unless File.directory? @code
      @code += "/#@name.rb"
    end

    @field["args"] = args

    if @caller.nil?
      buf = "IMP"
    else
      buf = @caller
    end

    puts "#{self} ~ #{buf}"
    # Msg[0] = to_s

    begin
      @@active = self
      load @code if File.file? @code
      @status = 0
    rescue => e
      raise e if @status.nil?
    ensure
      @@active = @caller
    end

  end

  def quit status

    @status = status

    puts "│"
    puts "@ #@status"
    case @status
    when 0
    when 1
      exit 1
    end

    raise

  end

  def to_s
    @name
  end

  def self.quit status
    return if @@active.nil?
    @@active.quit status
  end

  def self.field
    return if @@active.nil?
    @@active.field
  end

end
