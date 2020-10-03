todo = Task['args'][0]

if todo.empty?
  Err << 'no keywords provided'
  Task^1
end

index = Index.new todo

if index.empty?
  STDERR.puts 'no results found'
  exit
end

index.prepare!
index.get do |pkg|
  buf = pkg['name'] + ' (version ' + pkg['version'] + ')'
  puts buf
end
