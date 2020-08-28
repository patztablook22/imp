Task* "environment"
Msg.quiet = false

Task* "upgrade" if Env["imp-upgrade"]
Task* "filesystem"

target = Env["todo"]

if target.empty?
  Msg[-1] = Env.help
  exit
end

if Env["search"]
  action = "search"
else
  action = "install"
end


Task*[ "aur", action, target ]
Msg.oki
