#!/usr/bin/env ruby
require 'yaml'
require 'chatterbot/dsl'
require 'pry'
require 'awesome_print'

ME = "@borntoserveholt"

$quotes = YAML.load_file('hitchhiker.yml')

creds = YAML.load_file('creds.yml')
puts creds
consumer_secret creds['consumer_secret']
consumer_key    creds['consumer_key']
secret          creds['secret']
token           creds['token']

verbose

def compose_response(text, user)
  mentions = ["@#{user}"]
  # also get any other @mentions from the previous tweet
  mentions += text.scan(/@\w+/).select{|h| h != ME }
  
  return nil unless mentions.include? ME
  
  q = $quotes['responses'].sample
  
  if $quotes['names'] # try replacing names in quotes with @mentions
    r = /(#{$quotes['names'].join('|')})/
    if q =~ r # quote contains any of the names
      name = mentions.shift # take first name off the mentions list
      q = q.gsub(r, name) # replace name in quote with @mention
    end
  end
  
  "#{mentions.join(' ')} #{q}"  
end

streaming {
  
  followed {|user|
    tweet "@#{user.screen_name} #{$quotes['nonsequiturs'].sample}"
  }
  
  replies {|t|
    twt = compose_response(t.text, t.user.screen_name)
    if twt
      puts ">>> tweeting: '#{twt}'"
      reply twt[0...138], t
    end
  }
  
  direct_message {|m|
    unless ME =~ /#{m.sender.screen_name}/
      user = m.sender.screen_name
      txt = compose_response(m.full_text, user)
      client.create_direct_message("@#{user}", txt[0...138])
    end
  }
  
}
