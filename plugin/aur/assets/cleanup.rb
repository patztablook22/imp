# frozen_string_literal: true
Task^0 if Env['keep']

pkg  = Task['pkgdir']
pipe = Pipe.go! "sudo cp -r #{pkg}/. /"
unless pipe.ok?
  Task^1
end

Debug> pkg
