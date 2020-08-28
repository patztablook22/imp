action = Task["args"][0]
target = Task["args"][1]

case action
when "search"
  Task*["search", target]
  Task^0
when "exists"
when "install"
else
  Task^1
end

Task^1 if target.empty?
Task^1 if target =~ /[^a-zA-Z0-9\-]/

Task["pkgname"] = target
Task["aurdir" ] = Env["temp"] + "/aurdir/" + target
Task["srcdir" ] = Env["temp"] + "/srcdir/" + target
Task["pkgdir" ] = Env["temp"] + "/pkgdir/" + target

Task* "request"
Task* "depends"
Task* "sources"
Task* "makepkg"

Task^0 if Env["keep"]
Task> pkgname
Task*["export", Task["pkgdir"]]
