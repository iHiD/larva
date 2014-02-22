# Larva

[![Build Status](https://travis-ci.org/meducation/larva.png)](https://travis-ci.org/meducation/larva)
[![Dependencies](https://gemnasium.com/meducation/larva.png?travis)](https://gemnasium.com/meducation/larva)
[![Code Climate](https://codeclimate.com/github/meducation/larva.png)](https://codeclimate.com/github/meducation/larva)

Larva is a selection of helper classes used in Meducation's [pub/sub](http://en.wikipedia.org/wiki/Publish-subscribe_pattern) network. It builds upon [Propono](github.com/meducation/propono) and [Filum](github.com/meducation/filum).

## Installation

Add this line to your application's Gemfile:

    gem 'larva'

And then execute:

    $ bundle install

## Usage

### Listeners

Larva Listeners provide an easy way of listening to a Propono topic and processing the message, complete with lots of logging through Filum.

```ruby
class MyProcessor
  def self.process(message)
  end
end

Larva::Listener.listen(:my_topic, MyProcessor, "queue_suffix")
```

### Is it any good?

[Yes.](http://news.ycombinator.com/item?id=3067434)

## Contributing

Firstly, thank you!! :heart::sparkling_heart::heart:

We'd love to have you involved. Please read our [contributing guide](https://github.com/meducation/larva/tree/master/CONTRIBUTING.md) for information on how to get stuck in.

### Contributors

This project is managed by the [Meducation team](http://company.meducation.net/about#team). 

These individuals have come up with the ideas and written the code that made this possible:

- [Jeremy Walker](http://github.com/iHiD)
- [Malcolm Landon](http://github.com/malcyL)
- [Charles Care](http://github.com/ccare)
- [Rob Styles](http://github.com/mmmmmrob)

## Licence

Copyright (C) 2013-2014 New Media Education Ltd

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

A copy of the GNU Affero General Public License is available in [Licence.md](https://github.com/meducation/larva/blob/master/LICENCE.md)
along with this program.  If not, see <http://www.gnu.org/licenses/>.
