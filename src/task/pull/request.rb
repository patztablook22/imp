pkgname = Task["pkgname"]
aurdir  = Task["aurdir" ]
srcdir  = Task["srcdir" ]
pkgdir  = Task["pkgdir" ]

if Env["redo"] or !File.directory? aurdir

  FileUtils.rm_rf aurdir

  Task> pkgname
  
  giturl  = "https://aur.archlinux.org/#{pkgname}.git"
  command = String.new

  command << "git clone --quiet "
  command << giturl << " "
  command << aurdir

  pipe = Pipe.go! command

  if pipe.err.start_with? "warning"
    FileUtils.rm_rf aurdir
    Err << "package not found"
    Task^1
  end

end

Dir.chdir aurdir

pkgbuild = Pkgbuild.new
Task^1 unless pkgbuild.ok?

pkgbuild["srcdir"] = srcdir
pkgbuild["pkgdir"] = pkgdir

Task["pkgbuild"] = pkgbuild
