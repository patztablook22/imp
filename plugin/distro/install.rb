# frozen_string_literal: true
asset 'pm'

case pm
when 'xbps'

  pipe = Pipe.go! "xbps-install -y #{arg}"
  yield pipe.out
  yield pipe.err
  raise 'an error occurred' unless pipe.ok?
end

