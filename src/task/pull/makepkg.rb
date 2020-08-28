pkgbuild = Task["pkgbuild"]
function = ["prepare", "build", "package"]

function.each do |func|

  body = pkgbuild["#{func}()"][0]
  next if body.nil?

  Task> func

  # colons to make sure the function
  # has at least one command in it
  script  = "

    patch() {
      :
    }

    #{func}() {
      :
      #{body}
    }

    #{func}

  "

  pipe = Pipe.go! body
  unless pipe.ok?
    Task* "cleanup"
    Task^1
  end

end

