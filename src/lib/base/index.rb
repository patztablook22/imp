class Index

  @key
  @doc

  def initialize phrase
    @key = URI.encode_www_form_component(phrase)
    url  = "https://aur.archlinux.org/packages/?O=0&PP=250&K=#@key"
    url += "&&SeB=n"
    url += "d" if $env.verb?
    uri  = URI.parse url
    @doc = uri.open.read
  end

  def empty?
    if @doc =~ /<p>No packages matched your search criteria.<\/p>/
      true
    else
      false
    end
  end

  def prepare!

    pos = @doc.index /<tbody>/
    @doc = @doc[pos + 7 .. -1]
    
    pos = @doc.index /<\/tbody>/
    @doc = @doc[0 .. pos - 1]

    @doc.strip!
    @doc = @doc.split("</tr>")

  end

  def get &block
    @doc.each do |tr|

      tr.strip!
      td  = tr.split("\n")
      pkg = Hash.new

      pkg["name"]    = inner td[1]
      pkg["version"] = inner td[2]

      yield pkg

    end
  end

  # innerHTML, e.g. <td><a>THIS</a></td>
  def inner html
    html.strip!
    while html[0] == "<"
      html = html[ html.index(">") + 1 .. -1 ]
    end
    html[0 ... html.index("<")]
  end

end
