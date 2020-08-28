extend Phase

pkgbuild = get("pkgbuild")
depends = pkgbuild["depends"] + pkgbuild["makedepends"]

depends.clear if Env["skip"].include? "ALL"
depends.select! do |pkg|
  !Env["skip"].include? pkg
end
skip! if depends.none?

depends.map! do |dep|
  Depend.new dep
end

Depend.init
depends.each do |dep|
  log dep
  Err << "missing dependency: #{dep}" unless dep.present?
end
err if Err.ed?

