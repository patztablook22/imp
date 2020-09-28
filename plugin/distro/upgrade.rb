pkgers = {

  "apt"     => "apt-get",
  "pacman"  => "pacman",
  "dnf"     => "dnf-install",
  "yum"     => "yum",
  "xbps"    => "xbps-install",

}

distro = pkgers.find do |pkger, cmd|
  begin
    %x( #{cmd} )
    next true
  rescue
    next false
  end
end

Cache["distro"] = distro[0]
