require 'open-uri'

require_relative 'aura/index'

index = Index.new $env.todo
if index.empty?
  puts "no package found"
  exit
end
index.prepare!
index.get do |pkg|
  buf = pkg["name"] + " (version " + pkg["version"] + ")"
  puts buf
end
