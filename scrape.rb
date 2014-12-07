#!/usr/bin/env ruby
require 'curb'
require 'nokogiri'
require 'pry'

url = ARGV[0]
pages = ARGV[1].to_i

(1...pages).each do |i|
  c = Curl::Easy.new("#{url}?page=#{i}")
  if c.perform
    Nokogiri::HTML(c.body)
      .css("div.quoteText")
      .map{|e| e.text[/“(.*?)”/,1] }
      .select{|t| t.size < 140 }
      .map{|t| t.gsub(/(['"]).*said.*?\1/,' ') } # remove 'he said' bits
      .each{|t| puts t }
  end
end
