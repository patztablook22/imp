# frozen_string_literal: true
# forbid using any of these
# to prevent important data loss

dangerous = Array.new
filetrees = [
  $git,
  ENV["HOME"] + "/.config",
  ENV["HOME"] + "/Documents",
  ENV["HOME"] + "/Desktop",
  "/usr/bin",
  "/usr/share",
  "/usr/lib",
]

dangerous << "/"
filetrees.each do |tree|
  until tree == "/"
    dangerous << tree
    tree = File.dirname tree
  end
end

[
  Env["local"],
  Env["temp" ],
].each do |dir|

  if dangerous.include? File.expand_path(dir)
    Err << "using #{dir} is dangerous!"
    Cli.err
  end

  begin
    FileUtils.mkdir_p dir
  rescue
    Err << "permission denied: #{dir}"
    Cli.err
  end

end
