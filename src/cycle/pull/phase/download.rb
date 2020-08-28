extend Phase

pkgbuild = get("pkgbuild")
srcdir   = get("srcdir")
sources  = pkgbuild["source"]

FileUtils.rm_rf   srcdir if Env["redo"]
FileUtils.mkdir_p srcdir

sources.map! do |src|
  Source.new(src, srcdir)
end

set("sources", sources)

if File.exists? srcdir
  go! "checksum"
end

sources.each do |src|
  log src.to_s
  src.retrieve
  err if Err.ed?
end

