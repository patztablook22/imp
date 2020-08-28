Task> "imp"

# pull from git

Dir.chdir $git
pipe = Pipe.go! "git pull"

=begin
  Debug> pipe.ok?
  Debug> pipe.out
  Debug> pipe.err
=end

