pkgname = Task["args"][0]
Task["pkgname"] = pkgname

Task^1 if pkgname.empty?
Task^1 if pkgname =~ /[^a-zA-Z0-9\-]/

Task["aurdir"] = Env["temp"] + "/aurdir/" + pkgname
Task["srcdir"] = Env["temp"] + "/srcdir/" + pkgname
Task["pkgdir"] = Env["temp"] + "/pkgdir/" + pkgname

Task* "request"
Task* "depends"
Task* "sources"
Task* "makepkg"

Task^0 if Env["keep"]
Task> pkgname
Task*["export", Task["pkgdir"]]
