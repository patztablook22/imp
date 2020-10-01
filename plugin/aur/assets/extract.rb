# frozen_string_literal: true
file = Task?[0]
dir  = File.dirname file
base = file
exts = Array.new

while base =~ /\./

  ext = File.extname base

  break unless ext =~ /[a-zA-Z]+/

  base  = File.basename(base, ext)
  exts << ext[1..-1]

end

command = String.new

if exts.include? 'tar'
  command << 'tar -'
  command << 'z' if exts.any? { |it| it=~ /.z/ and it != 'xz' }
  command << 'xf '
  command << file
elsif exts.include? 'deb'
  command << 'ar -x '
  command << file
end

Task^0 if command.empty?
Task> File.dirname(file)

pwd = Dir.pwd # save working directory
Dir.chdir dir # change working directory

pipe = Pipe.go! command
Task^1 unless pipe.ok?

Dir.chdir pwd # change working directory back
