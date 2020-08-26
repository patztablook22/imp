$env.conf = "#$git/config.txt" # if not specified in options
$env.conf!  rescue err "unparseable config file"
