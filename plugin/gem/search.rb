buf = []

pipe = Pipe.go! "gem search \"#{arg}\" --quiet"
pipe.out&.each_line do |line|

  next if line.strip.empty?
  line = line.split

  pkg = Pkg.new
  pkg.name = line[0]
  pkg.version = line[1][1...-1]

  buf << pkg

end

return buf
