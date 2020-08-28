todo = Task["args"][0]

Task^0 if Env["find"]

Task^1 if todo.empty?
Task^1 if todo =~ /[^a-zA-Z0-9\-]/

Task["pkgname"] = todo
Task["aurdir" ] = Env["aurdir"] + "/" + todo
Task["srcdir" ] = Env["srcdir"] + "/" + todo
Task["pkgdir" ] = Env["pkgdir"] + "/" + todo

Task* "request"
Task* "depends"
Task* "sources"
Task* "install"
