# frozen_string_literal: true
buf = []

pipe = Pipe.go! 'xbps-query -l'
pipe.out.each_line do |line|

  line = line.split[1]
  line = line.split('-')

  pkg = Pkg.new
  pkg.name = line[0...-1].join('-')
  pkg.version = line[-1]

  buf << pkg

end

return buf
