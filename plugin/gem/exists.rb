# frozen_string_literal: true
pipe = Pipe.go! "gem info \"#{arg}\" --quiet"
return true if pipe.ok? and pipe.out.split("\n").size > 1
