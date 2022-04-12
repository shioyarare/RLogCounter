#! /usr/bin/env ruby
require './writer.rb'
require './filein.rb'
$stdout.sync = true
$empty_serializer = " "

# flags
$ignore_cached = true
$view_logtag   = true

# check args
if ARGV.length <= 0 then
  puts "input filename."
  exit
end
unless File.exist?(ARGV[0]) then
  puts "No such file '#{ARGV[0]}'."
end

# total calc
def rlogCount (rlogd)
  # Classification by serializer
  dict = {}
  rlogd.each do |e|
    key = *e.toArr
    dict[key] = dict.fetch(key, 0) + 1
  end

  return dict
end

class Rlog
  attr_accessor :query, :endpoint, :serializer
  def initialize(query, endpoint, serializer)
    @query      = query
    @serializer = serializer
    @endpoint   = endpoint
  end

  def toArr()
    return [@serializer, @endpoint, @query]
  end
end

fileInput(ARGV[0])