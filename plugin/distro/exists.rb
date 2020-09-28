pipe = Pipe.go! "xbps-query -R \"#{arg}\""
return pipe.ok?
