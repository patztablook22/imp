class Pipe

  @command

  @return
  @stdout
  @stderr

  def self.go! command
    pipe = Pipe.new
    pipe.command = command
    pipe.go!
    pipe
  end

  def initialize
    @command = "set -e\n"
  end

  def command= str
    @command << str rescue return
    @command.freeze
  end

  def go!

    ### old solution
    #
    # @stdout, @stderr, @return = Open3.capture3 @command
    # @return = @return.exitstatus

    stdin, stdout, stderr, thread = Open3.popen3 @command

    @stdout = stdout.read
    @stderr = stderr.read
    @return = thread.value

  end

  def ok?
    @return == 0
  end

  def out
    @stdout
  end

  def err
    @stderr
  end

end
