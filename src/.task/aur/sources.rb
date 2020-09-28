pkgbuild = Task["pkgbuild"]
srcdir   = Task["srcdir"]
sources  = pkgbuild["source"]

FileUtils.rm_rf   srcdir if Env["clean"]
FileUtils.mkdir_p srcdir

# find hashing algorithm
checksum = nil
pkgbuild.each do |key, val|
  checksum = key[0...-1] if key =~ /[a-z]+\d+sums/
end

it = 0
sources.map! do |source|

  hash = pkgbuild[ checksum + "s" ][it]
  it  += 1
  file = srcdir + "/"

  if source =~ /::/
    tmp    = source.split "::"
    file  += tmp[0]
    source = tmp[1]
  else
    file  += File.basename source
  end

  [file, hash, source]

end

Task["checksum"] = checksum

sources.each do |src|
  pair1 = [ src[0], src[1] ]
  pair2 = [ src[0], src[2] ]
  Task!( "checksum", pair1 ) == 0 && next
  Task!( "download", pair2 )
end

sources.each do |source|
  Task!( "checksum", source.take(2) ) != 0 && Task^1
  Task!( "extract" , source[0]      )
end
