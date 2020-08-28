Task> "defaults"

Env["help", false]
Env["...print help", "h"]

Env["verbose", false]
Env["...verbosity level", "v"]

Env["search", false]
Env["...search for package", "s"]

Env["imp-upgrade", false]
Env["...upgrade itself", "i"]

Env["depend", "", ["ALL"]]
Env["...skip given dependency", "d"]

Env["local", "#$git/local", :same]
Env["...imp-installed packages"]

Env["temp",  Env["local"] + "/.temp", :same]
Env["...dir for temporary files"]

Env["keep", false]
Env["...don't export package"]

Env["clean", false]
Env["...clean install"]

Env["printenv", false]
Env["...print environment"]

Env["todo", "", ""]
Env["...todo, but option format"]

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
  exit
end

if Env["printenv"]
  puts Env
  exit
end
