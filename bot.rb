#!/usr/bin/env ruby
require 'yaml'
require 'chatterbot/dsl'
require 'pry'

quotes = YAML.load_file('jeeves.yml')

creds = YAML.load_file('creds.yml')
puts creds
consumer_secret creds['consumer_secret']
consumer_key    creds['consumer_key']
secret          creds['secret']
token           creds['token']

verbose

streaming {
  
  followed {|user|
    tweet "@#{user.screen_name} #{quotes['nonsequiturs'].sample}"
  }
  
  replies {|tweet|
    self.pry
  }
  
}
