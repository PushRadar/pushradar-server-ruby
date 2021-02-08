<p align="center"><a href="https://pushradar.com" target="_blank"><img src="https://pushradar.com/images/logo/pushradar-logo-dark.svg" width="300"></a></p>

<p align="center">
    <a href="https://rubygems.org/gems/pushradar"><img src="https://img.shields.io/gem/v/pushradar?cacheSeconds=60&color=5b86e5"></a>
    <a href="https://rubygems.org/gems/pushradar"><img src="https://img.shields.io/gem/dt/pushradar?cacheSeconds=60&color=5b86e5"></a>
    <a href="https://rubygems.org/gems/pushradar"><img src="https://img.shields.io/packagist/l/pushradar/pushradar-server-php?cacheSeconds=60&color=5b86e5"></a>
</p>
<br />

## PushRadar Ruby Server Library

[PushRadar](https://pushradar.com) is a realtime API service for the web. The service uses a simple publish-subscribe model, allowing you to broadcast "messages" on "channels" that are subscribed to by one or more clients. Messages are pushed in realtime to those clients.

This is PushRadar's official Ruby server library.

## Prerequisites

In order to use this library, please ensure that you have the following:

- Ruby 2.4+
- A PushRadar account - you can sign up at [pushradar.com](https://pushradar.com)

## Installation

The easiest way to get up and running is to install the library using bundler. Add the following to your Gemfile:

```ruby
gem 'pushradar'
```

And then run bundle install:

```bash
$ bundle install
```

Alterntively, install manually by running `$ gem install pushradar`

## Broadcasting Messages

```ruby
require 'pushradar'

radar = PushRadar::Client.new('your-secret-key')
radar.broadcast('channel-1', {message: 'Hello world!'})
```

## Receiving Messages

```html
<script src="https://pushradar.com/js/v3/pushradar.min.js"></script>
<script>
    var radar = new PushRadar('your-public-key');
    radar.subscribe.to('channel-1', function (data) {
        console.log(data.message);
    });
</script>
```

## Private Channels

Private channels require authentication and start with the prefix **private-**. We recommend that you use private channels by default to prevent unauthorised access to channels.

You will need to set up an authentication endpoint that returns a token using the `auth(...)` method if the user is allowed to subscribe to the channel. For example:

```ruby
radar = PushRadar::Client.new('your-secret-key')
channel_name = params[:channelName]
# is user allowed to access channel?
if true
  return {'token': radar.auth(channel_name)}.to_json
end
```

Then register your authentication endpoint by calling the `auth(...)` method client-side:

```javascript
radar.auth('/auth');
```

## Complete Documentation

Complete documentation for PushRadar's Ruby server library can be found at: <https://pushradar.com/docs/3.x?lang=ruby>

## License

Copyright 2021, PushRadar. PushRadar's Ruby server library is licensed under the MIT license:
http://www.opensource.org/licenses/mit-license.php