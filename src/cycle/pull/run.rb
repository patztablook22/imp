extend Cycle

skip! if Env["todo"].empty?

set( "todo"  , Env["todo"]                       )
set( "aurdir", Env["aurdir"] + "/" + get("todo") )
set( "srcdir", Env["srcdir"] + "/" + get("todo") )
set( "pkgdir", Env["pkgdir"] + "/" + get("todo") )

go! "request"
go! "depends"
new

go! "download"
new

go! "checksum"
go! "extract"
new

go! "install"
oki
