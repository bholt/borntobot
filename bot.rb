#!/usr/bin/env ruby
require 'yaml'
require 'chatterbot/dsl'
require 'pry'

ME = "@borntoserveholt"

quotes = YAML.load_file('hitchhiker.yml')

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
    mentions = ["@#{t.user.screen_name}"]
    # also get any other @mentions from the previous tweet
    mentions += t.text.scan(/@\w+/).select{|h| h != ME }
    
    q = quotes['responses'].sample
    
    if quotes['names'] # try replacing names in quotes with @mentions
      r = /(#{quotes['names'].join('|')})/
      if t =~ r # quote contains any of the names
        name = mentions.shift # take first name off the mentions list
        q = t.gsub(r, name) # replace name in quote with @mention
      end
    end
    
    twt = "#{mentions.join(' ')} #{q}"
    puts ">>> tweeting: '#{twt}'"
    reply twt[0...138], t
  }
  
}
