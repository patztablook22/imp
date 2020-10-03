def sources pkgbuild

  aurdir  = pkgbuild['aurdir'][0]
  srcdir  = pkgbuild['srcdir'][0]
  sources = pkgbuild['source']

  FileUtils.rm_rf   srcdir if Env['clean']
  FileUtils.mkdir_p srcdir

  return if sources.none?

  # find hashing algorithm
  checksum = nil
  pkgbuild.each do |key, val|
    checksum = key[0...-4].upcase if key =~ /[a-z]+\d+sums/
  end

  yield "using hashing: #{checksum}"
  func = Checksum.const_get(checksum)

  it = 0
  sources.map! do |src|

    hash   = pkgbuild[ checksum.downcase + 'sums' ][it]
    it    += 1
    target = srcdir + '/'

    if source =~ /::/
      tmp     = src.split '::'
      target += tmp[0]
      source  = tmp[1]
    else
      target += File.basename src
      source  = src
    end

    [source, target, hash]

  end

  sources.each do |src|

    begin
      prog = func.new src[1] => src[2]
      yield prog
      next if prog.ok?
    rescue
    end

    if src[0] =~ /http(s)?:\/\//
      yield Download.new src[0] => src[1]
    else
      src[0] = aurdir + '/' + src[0]
      yield "copying: #{src[1]}"
      FileUtils.cp_r src[0], src[1]
    end

  end

  sources.each do |src|
    yield func.new src[1] => src[2]
  end

end
