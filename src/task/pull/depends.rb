pkgbuild = Task["pkgbuild"]
depends  = Array.new
depends += pkgbuild["depends"]
depends += pkgbuild["makedepends"]

depends.clear if Env["skip"].include? "ALL"
depends.select! do |pkg|
  !Env["skip"].include? pkg
end
Task^0 if depends.none?

depends.map! do |dep|
  Depend.new dep
end

Depend.init
depends.each do |dep|
  Task> dep
  Err << "missing dependency: #{dep}" unless dep.present?
end
Task^1 if Err.ed?

