Task> "defaults"

Env["help", false]
Env["...print help", "h"]

Env["verbose", false]
Env["...verbosity level", "v"]

Env["search", false]
Env["...search for package", "s"]

Env["remove", false]
Env["...remove package", "r"]

Env["list", false]
Env["...list installed packages", "l"]

Env["imp-upgrade", false]
Env["...upgrade itself", "i"]

Env["tui", false]
Env["...force text user interface"]

Env["depend", "", ["ALL"]]
Env["...skip given dependency", "d"]

Env["local", "#$git/local", :same]
Env["...imp-installed packages"]

Env["temp",  Env["local"] + "/.temp", :same]
Env["...dir for temporary files"]

Env["keep", false]
Env["...don't export package"]

Env["clean", "", ""]
Env["...clean install"]

Env["env", false]
Env["...export imp env"]

Env["todo", "", ""]
Env["...todo, but option format"]

Env["plugin", false]
Env["...show plugins"]

Env["debug", false]
Env["...debug mode"]

Task^1 if Err.ed?
Task> "config.txt"

Env << Config
Task^1 if Err.ed?

Task> "options"
Env << Options
Task^1 if Err.ed?

if Env["help"]
  puts Env.help
  App.quit
end

if Env["env"]
  puts Env
  App.quit
end

if Env["plugin"]
  Plugin.init "#$git/plugin"
  Plugin.each do |p|
    Cli[-1] = Cli.tab(p.name, 8) + " =>   " + Cli.tab(p.desc, 0)
  end
  App.quit
end

App.init Env["tui"]
#Plugin.init "#$git/plugin"

