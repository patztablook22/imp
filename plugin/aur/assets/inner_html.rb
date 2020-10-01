# frozen_string_literal: true
def inner html
  html.strip!
  while html[0] == "<"
    html = html[ html.index(">") + 1 .. -1 ]
  end
  html[0 ... html.index("<")]
end
