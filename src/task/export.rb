pkgdir  = Task["args"][0]
pkgname = File.basename pkgdir

Task> pkgname

pipe = Pipe.go! "sudo cp -r '#{pkgdir}/.' /"
pipe.go!

unless pipe.ok?
  Err << pipe.err
  Task^1
end
