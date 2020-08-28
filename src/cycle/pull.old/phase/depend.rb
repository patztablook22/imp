depends = pkgbuild["depends", false] + pkgbuild["makedepends", false]
depends.map! do |pkg|
  next if $env.skip? pkg
  Depend.new(pkg)
end
depends.compact!

Depend.init if depends.any?
depends.each do |dep|
  unless dep.present?
    Console.err("package not found")
  end
end

Console.end

if $env.redo
  FileUtils.rm_rf(srcdir)
end

if File.exists? srcdir
  sources = []
else
  Dir.mkdir(srcdir)
  sources = pkgbuild["source", false]
  sources = sources.to_a
  sources.map! do |path|
    Source.new(path, srcdir)
  end
end

sources.each do |src|
  src.retrieve rescue
  begin
    Console.err("failed to open stream")
  end
end

Console.end

sources.each do |src|
  src.extract
end

Console.end

Dir.chdir srcdir

["prepare", "build", "package"].each do |func|

  Console.log("installing", func)

  body  = "patch(){\n:\n}\n"
  body += func + "(){\n"
  body += pkgbuild[func + "()"][0].to_s
  body += "\n:\n}\n" # to prevent empty function
  body += func

  pipe  = Pipe.go! body

  unless pipe.ok?
    Console << pipe.err
    Console.err("compatibility?")
  end

end

Console.oki
