Task! "environment"
Cli.quiet = false

Task! "upgrade" if Env["imp-upgrade"]
Task! "filesystem"

target = Env["todo"]

unless target.empty?

  if Env["search"]
    action = "search"
  else
    action = "install"
  end

  Task!("aur", action, target)

  Cli.oki

end

unless App.tui?
  Cli[-1] = Env.help
  App.quit
end

sleep 1 while true
