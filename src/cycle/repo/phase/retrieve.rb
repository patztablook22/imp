extend Phase

skip! unless Env["find"]

log "search results"
if Env["todo"].empty?
  Err << "no keywords provided"
  err
end

index = Index.new Env["todo"]
del

if index.empty?
  STDERR.puts "no results found"
  exit
end

index.prepare!
index.get do |pkg|
  buf = pkg["name"] + " (version " + pkg["version"] + ")"
  puts buf
end
