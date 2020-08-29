Task> "imp"

# pull from git

Dir.chdir $git
pipe = Pipe.go! "git pull"

=begin
  Debug> pipe.ok?
  Debug> pipe.out
  Debug> pipe.err
=end

args = String.new

Env.each do |key|
  next if key == "imp-upgrade"
  val = Env[key]
  val = case val
        when true;  "true"
        when false; "false"
        when Array;  val.join("\ ")
        else         val.to_s
        end
  next if val.empty?

  if key == "debug"
    args << "--#{key}" if val == true
    next
  end

  args << " --#{key}=#{val}"
end

exec($0 + args)
