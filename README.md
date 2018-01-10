# Deis Interactive

This gem provide a way to quickly invoke interactive task to a deis
cluster. The gem assumes that you have kubectl installed and configured.

The initial version only feature "deis-rails console -a APP". Hopefully
overtime other contributors join and we have more tools readily to be
used for Rails and other Python project. Pull requests are welcomed.

## Installation

Add this line to your application's Gemfile:

    gem 'deis-interactive', require: false

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install deis-interactive

## Usage

Runing console for your Rails app:

    $ bundle exec deis-rails console -a MY-APP

Logs for your Rails app:

    $ bundle exec deis-rails logs -a MY-APP -p MY-PROCESS -f


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
