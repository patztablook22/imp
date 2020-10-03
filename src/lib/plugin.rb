class Plugin

  @@all = []
  @@dir = nil

  def self.init
    return unless @@dir.nil?
    @@dir = "#$git/plugin"
    Dir["#@@dir/*"].each do |dir|
      Plugin.new File.basename(dir)
    end
    @@all.sort_by!(&:nice)
  end

  def self.each &block
    return @@all unless block_given?
    @@all.each do |p|
      yield p
    end
  end

  def self.size
    @@all.size
  end

  def self.method_missing action, *args, &hook
    buf = []
    each do |plug|
      buf << plug.send(action, *args, &hook)
    end
    buf
  end

  def self.[] name
    @@all.find { |p| p.name == name }
  end

  @name
  @desc
  @nice
  @list
  @dir

  attr_reader :name, :desc, :nice, :list, :dir

  private

  def initialize name

    man    = "#@@dir/#{name}/MANIFEST"
    return unless File.file? man
    parser = Parser.new File.new(man)

    @name = name
    @desc = parser.data['desc'][0]
    @nice = parser.data['nice'][0]
    @list = parser.data['list']
    @list = true if @list.nil?
    @dir  = "#@@dir/#@name"

    return unless @nice and @desc

    return unless [
      'exists', 'install', 'search' # "plugin", "local", "remove" optional
    ].all? do |task|
      File.file? "#@@dir/#@name/#{task}.rb"
    end

    @@all << self
    
  end

  def method_missing action, *args, &hook

    action = action.to_s
    result = case action
             when 'upgrade'
               -> { run('upgrade') }
             when 'local', 'search'
               -> {
                 r = run(action, args[0])
                 r = case r
                     when NilClass
                       []
                     when Array
                       r
                     else
                       [r]
                     end
                 r.each do |pkg|
                   pkg.plugin = name
                 end
               }
             when 'exists'
               -> { run('exists', args[0]) == true }
             when 'install'
               -> {
                 run(action, args[0]) and \
                 App.popup 'done', "Successfully installed #{args[0]}", -> {
                   App.tab 'search'
                   nil while App.pupop
                   App.focus 'result'
                 }
               }
             when 'remove'
               -> { run(action, args[0]) }
             end

    return if result.nil?

    if block_given?
      return Thread.new { yield result.call }
    else
      return result.call
    end

  end

  private

  def run action, arg = nil
    App.log
    script(action, arg) do |prog|
      if [ prog.class.superclass, prog.class.superclass.superclass ].include? Progress
        prog.go!
        App.log "#{prog.head}: #{prog.body}"
      else
        App.log prog
      end
    end
  end

  def script action, arg
    path = "#@@dir/#@name/#{action}.rb"
    begin
      eval File.read(path)
      return true
    rescue Errno::ENOENT
    rescue => e
      yield e
      App.popup 'error', 'restart', {
        true  => -> { App.log; sleep 0.2; run action, arg  },
        false => -> { App.tab 'search'; App.focus 'result' },
      }
      return false
    end
  end

  private
  def asset path
    run("assets/#{path}")
  end

end
