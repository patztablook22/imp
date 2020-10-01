# frozen_string_literal: true
asset 'inner_html'

buf = Array.new

begin

  key  = URI.encode_www_form_component(arg)
  url  = "https://aur.archlinux.org/packages/?O=0&PP=250&K=#{key}"
  url += "&SeB=n"
  uri  = URI.parse(url)
  doc  = uri.open.read

  return if doc =~ /<p>No packages matched your search criteria\.<\/p>/

  pos = doc.index /<tbody>/
  doc = doc[pos + 7 .. -1]

  pos = doc.index /<\/tbody>/
  doc = doc[0 .. pos - 1]

  doc.strip!
  doc = doc.split("</tr>")

  doc.each do |tr|
    tr.strip!
    tds = tr.split("\n")
    pkg = Pkg.new
    pkg.name    = inner tds[1]
    pkg.version = inner tds[2]
    pkg.desc    = inner tds[5]
    buf << pkg
  end

rescue
end

return buf
