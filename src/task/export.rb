pkgdir = Task["args"][0]

pipe = Pipe.go! "sudo cp -r '#{pkgdir}/.' /"
pipe.go!

unless pipe.ok?
  Err << pipe.err
  Task^1
end
