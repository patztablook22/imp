require_relative 'var'

module Env

  # data
  @@data = {

    "help"         =>    Boolean.new,
    "search"       =>    Boolean.new,
    "imp-upgrade"  =>    Boolean.new,
    "depend"       =>       List.new,
    "verbose"      =>     Abacus.new,
    "local"        =>       Text.new,
    "temp"         =>       Text.new,
    "keep"         =>    Boolean.new,
    "clean"        =>    Boolean.new,
    "todo"         =>       Text.new,
    "env"          =>       Text.new,
    "debug"        =>    Boolean.new,

  }

  # last token modified
  @@last

  ### assign value, then assign meta
  ### yes, the syntax below is valid
  #
  # Env["token", "value"]
  # Env["...example variable", "t"]
  #
  #
  ### get value
  #
  # Env["token"]  => "value"
  #
  #
  ### set value, then get value
  #
  # Env["token", "change"]
  # Env["token"]  => "change"
  # 
  #
  ### also accessible using -x opt, if available
  #
  # Env["-t"] => "change"
  #
  #
  def self.[] *args

    if args[0] =~ /\A\.\./

      raise if @@last.nil?

      man = args[0].gsub(/\A\.+/, "")
      opt = args[1]

      @@data[@@last].man = man
      @@data[@@last].opt = opt

      return

    end

    token = args[0]
    value = args[1]
    empty = args[2]

    if token[0] == "-"

      token = token[1..-1]
      found = nil

      @@data.each do |key, var|
        if var.opt == token
          found = key
          break
        end
      end

      if found.nil?
        Err << "no such token: -#{token}"
        return
      end

      token = found

    end

    unless @@data.include? token
      Err << "no such token: #{token}" 
      return
    end

    if value.nil? and empty.nil?
      @@data[token].get
    else
      @@last = token
      @@data[token].value value
      @@data[token].empty empty
    end

  end

  def meta token, man, opt
    @@data[token]&.man = man
    @@data[token]&.opt = opt
  end

  # dump var help
  def self.helpVar token

    var = @@data[token]
    buf = String.new

    return "" if var.nil? or var.man.nil?

    if var.opt.nil?
      buf << "     "
    else
      buf << "  -#{var.opt},"
    end

    buf << " --" << Msg.tab(token, longest + 4)
    buf << var.man
    buf << "\n"

    buf

  end

  # dump all help
  def self.help

    buf = String.new
    buf << "imp [options] todo\n"

    @@data.each do |key, var|
      next if var.opt.nil?
      buf << helpVar(key)
    end

    if Env["verbose"] == 0
      buf << "(verbose for more)"
      return buf
    end

    @@data.each do |key, var|
      next unless var.opt.nil?
      buf << helpVar(key)
    end

    buf
  end

  # export env
  def self.to_s

    buf = String.new
    @@data.each do |key, var|

      val = var.get
      val = val.join(" ") if val.class == Array

      next if key == "env" or val.to_s.empty?

      buf << Term.tab(key, longest, true) << " = "
      buf << val.to_s
      buf << "\n"

    end

    buf

  end

  def self.each &block
    @@data.each_key do |key|
      yield key
    end
  end

  # import environment
  def self.<< import

    return if import.nil?

    if import.class == String
      parser = Parser.new import
      data   = parser.data
    else
      data   = import.parse
    end

    return if data.nil?

    Var.bump!

    data.each do |key, val|
      val = val[0] if val.class == Array and val.size == 1
      self[key, val]
    end

  end

  private

  def self.longest
    tmp = 0
    @@data.each_key do |key|
      len = key.length
      tmp = len if len > tmp
    end
    tmp
  end

end
