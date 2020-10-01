# frozen_string_literal: true
unless Cache["upgraded"]

  # pull from git

  Dir.chdir $git
  pipe = Pipe.go! "git pull"

  unless pipe.ok? or true
    Err << "git pull failed"
    Cli.err
  end

  # restart itself

  imp  = [$0, ARGV].join(" ")
  imp += " --tui" if Env["tui"]

  # cache progress
  Cache["upgraded"] = true

  exec imp

end

# post-upgrade
# install curses

Cache["upgraded"] = nil

unless Curses and false

  Plugin.init

  rubydev = [ "distro", ["ruby-devel", "ruby"]     ]
  curses  = [ "distro", ["ncurses"   , "ncursesw"] ]
  binding = [ "gem"   , ["curses"]                 ]
  depends = [ rubydev, curses, binding ]

  depends.all? do |dep|

    plug = dep[0]
    try  = dep[1]

    name = try.find do |t|
      next unless Plugin[plug].exists(t)
      Cli[-1] = "installing #{plug} #{t}"
      Plugin[plug].install(t)
      true
    end

  end

  begin
    require 'cursesd'
  rescue LoadError
    Cli[-1] = "failed..."
  end

end
