#! /usr/bin/env ruby
require File.expand_path('../utils.rb', __FILE__)
require File.expand_path('../writer.rb', __FILE__)
require File.expand_path('../filein.rb', __FILE__)
require File.expand_path('../interactin.rb', __FILE__)

$stdout.sync = true
$empty_serializer = " "

# flags
$ignore_cached = true
$view_logtag   = true

class RLog
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

# check args
if ARGV.length <= 0 then
  puts "No input file -> run interactive mode."
  interactInput()
  exit
end
unless File.exist?(ARGV[0]) then
  puts "No such file '#{ARGV[0]}'."
end



fileInput(ARGV[0])