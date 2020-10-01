# frozen_string_literal: true
pipe = Pipe.go! "xbps-query -R \"#{arg}\""
return pipe.ok?
