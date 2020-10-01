# frozen_string_literal: true
buf = Array.new

pipe = Pipe.go! "gem list --quiet"
pipe.out.each_line do |line|

  line = line.split

  pkg = Pkg.new
  pkg.name = line[0]
  
  line = line[1..-1].join[1...-1]
  
  if line.start_with? "default:"
    pkg.version = line.split(":")[1..-1].join(":")
  else
    pkg.version = line
  end

  buf << pkg

end

return buf
