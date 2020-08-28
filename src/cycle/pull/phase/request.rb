extend Phase

aurdir = get("aurdir")

if Env["redo"] or !File.directory? aurdir

  FileUtils.rm_rf aurdir

  log get("todo")
  
  giturl  = "https://aur.archlinux.org/#{Env["todo"]}.git"
  command = String.new

  command << "git clone --quiet "
  command << giturl << " "
  command << aurdir

  pipe = Pipe.go! command

  if pipe.err.start_with? "warning"
    FileUtils.rm_rf aurdir
    del
    STDERR.puts "package not found"
    exit 1
  end

end

Dir.chdir aurdir

pkgbuild = Pkgbuild.new
err unless pkgbuild.ok?

pkgbuild["srcdir"] = get("srcdir")
pkgbuild["pkgdir"] = get("pkgdir")
set("pkgbuild", pkgbuild)

