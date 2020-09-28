asset 'request'
asset 'depends'
asset 'sources'
asset 'makepkg'

pkgname = arg
aurdir  = Env["temp"] + "/aurdir/" + pkgname
srcdir  = Env["temp"] + "/srcdir/" + pkgname
pkgdir  = Env["temp"] + "/pkgdir/" + pkgname

yield "requesting package"

pkgbuild = request(pkgname, aurdir) do |msg|
  yield msg
end

raise "pkgbuild failed" unless pkgbuild

pkgbuild["aurdir"] = aurdir
pkgbuild["srcdir"] = srcdir
pkgbuild["pkgdir"] = pkgdir

depends(pkgbuild) do |msg|
  yield msg
end

sources(pkgbuild) do |msg|
  yield msg
end

makepkg(pkgbuild) do |msg|
  yield msg
end
