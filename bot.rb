#!/usr/bin/env ruby
require 'yaml'
require 'chatterbot/dsl'
require 'pry'

ME = "@borntoserveholt"

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
  
  replies {|t|
    mentions = t.text.scan(/@\w+/).select{|h| h != ME }
    reply "@#{t.user.screen_name} #{mentions.join(' ')} #{quotes['responses'].sample}"[0...138], t
  }
  
}
