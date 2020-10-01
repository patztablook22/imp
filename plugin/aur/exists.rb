# frozen_string_literal: true
begin

  key = URI.encode_www_form_component(arg)
  url = "https://aur.archlinux.org/packages/#{key}"
  uri = URI.parse(url)
  doc = uri.open.read

  return false if doc =~ /<h2>404 - Page Not Found<\/h2>/
  return true

rescue
end
