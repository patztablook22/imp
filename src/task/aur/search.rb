todo = Task["args"][0]
Task> "Arch User Repository"

index = Index.new todo

if index.empty?
  Msg[-1] = "no packages found"
  exit
end

index.prepare!
index.get do |pkg|
  buf = pkg["name"] + " (version " + pkg["version"] + ")"
  Msg[-1] = buf
  exit
end
