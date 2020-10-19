# imp!

API for Intelligently Managed Packages. The core gem for IMP-related code. Provides daemon and client Ruby API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'imp-api'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install imp-api

## Usage

```ruby
require 'imp'

IMP.start_daemon
IMP.open
IMP.do_stuff
IMP.close

```

## Development

After checking out the repo, run `bundle install` to install dependencies. For quick interactive API ruby console, use `bin/imp`.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `lib/api/version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/imp-package-manager/imp-api.


## License

The gem is available as open source under the terms of the [GPL-3.0 license](https://opensource.org/licenses/GPL-3.0).
