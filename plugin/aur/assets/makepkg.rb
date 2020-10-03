def makepkg pkgbuild

  srcdir   = pkgbuild['srcdir'][0]
  pkgdir   = pkgbuild['pkgdir'][0]
  function = ['prepare', 'build', 'package']

  Dir.chdir srcdir

  FileUtils.rm_rf   pkgdir
  FileUtils.mkdir_p pkgdir

  function.each do |func|

    body = pkgbuild["#{func}()"][0]
    next if body.nil?

    yield func

    # colons to make sure the function
    # has at least one command in it
    script = "

    patch() {
      :
    }

    #{func}() {
      #{body}
    }

    #{func}

    "

    pipe = Pipe.go! "bash -c '#{script}'"
    unless pipe.ok?

      err = pipe.err

      # if shell syntax error
      if err =~ /\Ash: \d+: /

        errline = err.split(': ')[1].to_i
        script.split("\n").each_with_index do |line, number|

          next if number < 5

          if number == errline
            buf = '>>> '
          else
            buf = '    '
          end

          buf << errline.to_i
          buf << Msg.tab(number, 3, true)
          buf << '    ' + line

          Err << buf

        end

      end

      yield err

      raise 'erred'

    end

  end

end
