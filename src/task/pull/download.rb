file = Task["args"][0][0]
path = Task["args"][0][1]

Task> path

buff = File.open(file, 'w')

if path =~ /http(s):\/\//

  url = URI(path)

  Net::HTTP.start(url.hostname) do |http|
    head  = http.request_head url
    uri   = URI.parse path
    buff << uri.open.read
  end

else

  buff << File.open(path).read

end

buff.close
