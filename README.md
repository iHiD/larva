# Larva

[![Build Status](https://travis-ci.org/iHiD/larva.png)](https://travis-ci.org/iHiD/larva)
[![Dependencies](https://gemnasium.com/iHiD/larva.png?travis)](https://gemnasium.com/iHiD/larva)
[![Code Climate](https://codeclimate.com/github/iHiD/larva.png)](https://codeclimate.com/github/iHiD/larva)

Larva is a Ruby daemon builder based on top of the [Propono](github.com/meducation/propono) [pub/sub](http://en.wikipedia.org/wiki/Publish-subscribe_pattern) library and the [Filum](github.com/meducation/filum) logging library.

It is the foundation for daemons in Meducation's infrastructure.

Getting started is simple. Just install the gem and run 

```ruby
larva spawn my_daemon_name
```

## Installation

If you want to add this to an existing daemon, add this line to your application's Gemfile:

    gem 'larva'

And then execute:

    $ bundle install

## Usage

Larva provides you with listeners, processors and a worker pool to quickly build an application that listens and responds to Propono messages.

Here is a sample application that forms the basis of a rake task for most Meducation daemons.

```ruby
require 'larva'

# Setup Config for Filum and Propono

class MyProcessor < Larva::Processor
  def comment_created
    # I get called when the message is received :)
  end
end

processors = {my_topic: MyProcessor}
Larva::WorkerPool.start(processors, "queue-suffix")

# In another application...
Propono.publish(:my_topic, {entity: "comment", action: "created", id: 8}

```

### Listeners

Larva Listeners provide an easy way of listening to a Propono topic and processing the message, complete with lots of logging through Filum.

```ruby
Larva::Listener.listen(:my_topic, processor, "queue_suffix")
```

This will listen for messages on :my_topic and pass them to `processor.process`. It will log what is happening via Filum.

### Processors

Processors are used by listeners to handle the messages that are received.

If your messages have an `entity` and `action` fields, then you can create methods named `#{entity}_#{action}, which get called when a message is received.

For example:

```ruby
class MyProcessor < Larva::Processor
  def comment_created
    # I get called for the first message
  end
end
Larva::Listener.listen(:my_topic, MyProcessor, "")
Propono.publish(:my_topic, {entity: "comment", action: "created", id: 8}
```

If those methods do not exist, then a method called `process` is called. This method has acccess to `message`, `action`, `entity` and `id` fields. If this returns true, then the message is considered processed, else if it returns false, an error wil be logged.

For example:

``` ruby
class MyProcessor
  def process
    if message[:foo] == bar
      # Larva will consider this message processed successfully
      true
    else
      # An error is logged for this message
      false
    end
  end
end
Larva::Listener.listen(:my_topic, MyProcessor, "")
Propono.publish(:my_topic, {foo: "bar"} # -> Will be logged as a success
Propono.publish(:my_topic, {foo: "meh"} # -> Will be logged as unprocessed.
```

### Worker Pool

The worker pool creates a listener for each topic, and proxies messages to the associated processors. If any processors die, the application will die.

Creating a worker pool is trivial:

```ruby
processors = {
  my_topic_1: MyProcessor1
  my_topic_2: MyProcessor2
}
Larva::WorkerPool.start(processors, "queue-suffix")
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
