Task* "environment"
Msg.quiet = false


Task* "upgrade"
Task* "filesystem"

Task*[ "aur", Env["todo"] ]
