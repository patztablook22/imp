require_relative 'var'

module Env

  # data
  @@data = {

    "help"         =>    Boolean.new,
    "skip"         =>       List.new,
    "verbose"      =>     Abacus.new,
    "find"         =>    Boolean.new,
    "keep"         =>    Boolean.new,
    "redo"         =>    Boolean.new,
    "dump"         =>    Boolean.new,
    "clean"        =>    Boolean.new,
    "imp-upgrade"  =>    Boolean.new,
    "printenv"     =>    Boolean.new,
    "aurdir"       =>       Text.new,
    "srcdir"       =>       Text.new,
    "pkgdir"       =>       Text.new,
    "todo"         =>       Text.new,

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
      if false
        puts
        puts "AAAAAAAAAAAAAAAAAAAAAAAAA"
        pp token
        pp value
        pp empty
        pp args
      end
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

    buf << " --" << Msg.tab(token, 13)
    buf << " " << var.man
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

  # dump env pairs
  def self.to_s
    buf = String.new
    @@data.each do |key, var|

      buf << key << " = "

      unless var.nil?
        buf << var.get.to_s
      end

      buf << "\n"

    end
    buf
  end

  # import environment from parseable object
  # object.parse should return Hash
  def self.<< object

    data = object.parse

    Var.bump!

    data.each do |key, val|

      val = val[0] if val.class == Array and val.size == 1
      self[key, val]

    end

  end

end
