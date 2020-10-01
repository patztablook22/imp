# frozen_string_literal: true
def depends pkgbuild

  depends  = Array.new
  depends += pkgbuild['depends']
  depends += pkgbuild['makedepends']

=begin
  depends.clear if Env["depend"].include? "ALL"
  depends.select! do |pkg|
    !Env["depend"].include? pkg
  end
  return true
=end

  depends.map! do |dep|
    Depend.new dep
  end

  Depend.init

  depends.each do |dep|
    yield "checking dependency: #{dep}"
    unless dep.present?
      raise "missing dependency: #{dep}"
    end
  end

end
