file = Task["args"][0][0]
path = Task["args"][0][1]

=begin
  Debug> file
  Debug> path
=end

Task> path

buff = File.open(file, 'w')

if path =~ /http(s)?:\/\//

  url = URI(path)

  Net::HTTP.start(url.hostname) do |http|
    head  = http.request_head url
    uri   = URI.parse path
    buff << uri.open.read
  rescue
    Err << "404: #{path}"
    Task^1
  end

else

  buff << File.open(path).read

end

buff.close
