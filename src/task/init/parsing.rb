Task> "defaults"

Env["help", false]
Env["...print help", "h"]

Env["verbose", false]
Env["...verbosity level", "v"]

Env["find", false]
Env["...find all pkg matches", "f"]

Env["skip", "", ["ALL"]]
Env["...skip dependency", "s"]

Env["keep", false]
Env["...keep pkgdir fakeroot", "k"]

Env["redo", false]
Env["...redo everything", "r"]

Env["dump", false]
Env["...dump pkgdir fakeroot", "d"]

Env["clean", false]
Env["...clean pkgdir fakeroot", "c"]

Env["imp-upgrade", false]
Env["...upgrade itself", "i"]

Env["aurdir", "#$git/local/aurdir", :same]
Env["...local aur repo"]

Env["srcdir", "#$git/local/srcdir", :same]
Env["...temp dir for sources"]

Env["pkgdir", "#$git/local/pkgdir", :same]
Env["...temp fakeroot for packages"]

Env["printenv", false]
Env["...print environment"]

Env["todo", "", ""]
Env["...todo, but option format"]

Task^1 if Err.ed?
Task> "config.txt"

Env << Config
Task^1 if Err.ed?

Task> "options"
Env << Options
Task^1 if Err.ed?

Msg.quiet = false

if Env["help"]
  puts Env.help
  exit
end

if Env["printenv"]
  puts Env
  exit
end
