asset 'pm'

buf = Array.new

case pm
when "xbps"

  pipe = Pipe.go! "xbps-query -Rs \"#{arg}\""
  pipe.out.each_line do |line|

    line = line.split
    desc = line[2..-1]
    line = line[1].split("-")

    pkg = Pkg.new
    pkg.name = line[0...-1].join("-")
    pkg.version = line[-1]
    pkg.desc = desc.join(" ")

    buf << pkg

  end

end

return buf
