# em-sessions #

em-sessions is rest-sessions ruby client, about see: [rest-sessions](https://github.com/smrchy/rest-sessions).

## Installation ##

Install em-sessions as a gem:

```
gem install em-sessions
```

or add to your Gemfile:

```ruby
# Gemfile
gem 'em-http-request'
gem 'em-sessions'

```

and run `bundle install` to install the dependency.


## Initialize ##

```ruby
# default: init(url = 'localhost:3000', app = 'weapp')
Em::Sessions.init
client = Em::Sessions.client
```
## Notice ##
client`s all methods return two params, one code, one json, such as:
```ruby
 client.create('1') # [200, {"token": "9kwi9wu429dkw8urkhr923jrekw32" ]
```
you can
```ruby
 code, json = client.create('1')
 json['token'] # 9kwi9wu429dkw8urkhr923jrekw32
```

## Use List ##

```ruby

  client.create(id, out_time = 7200, ip = '0.0.0.0')

  client.find_by_token(token)

  client.find_by_id(id)

  client.set_params_by_token(token, params = {})

  client.delete_by_token(token)

  client.delete_by_id(id)

  client.delete_all

  client.activity?
```



## Copyright ##

Copyright © 2011-2016. See [LICENSE](https://github.com/millim/em-sessions/blob/master/LICENSE.txt) for details.
