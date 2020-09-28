def request pkgname, aurdir

  if !File.directory? aurdir or Env["clean"]

    FileUtils.rm_rf aurdir

    giturl  = "https://aur.archlinux.org/#{pkgname}.git"
    command = String.new

    command << "git clone --quiet "
    command << giturl << " "
    command << aurdir

    pipe = Pipe.go! command

    if pipe.err.start_with? "warning"
      FileUtils.rm_rf aurdir
      yield "package not found"
      return
    elsif pipe.err.start_with? "fatal"
      yield "network"
      return
    end

  end

  Dir.chdir aurdir

  pkgbuild = Pkgbuild.new
  unless pkgbuild.ok?
    yield "parsing PKGBUILD failed"
    return
  end

  return pkgbuild

end
