#! /usr/bin/env ruby
$stdout.sync = true
require File.expand_path('../utils.rb', __FILE__)
require File.expand_path('../writer.rb', __FILE__)
require File.expand_path('../read_core.rb', __FILE__)


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
  ReadCore.init(
    is_interactive  = true,
    view_logtag     = true,
    ignore_cache    = true,
    query_min_count = -1
  )
  while line = gets
    ReadCore.index(line)
  end
  exit
end

unless File.exist?(ARGV[0]) then
  puts "No such file '#{ARGV[0]}'."
end

ReadCore.init(
  is_interactive  = false,
  view_logtag     = true,
  ignore_cache    = true,
  query_min_count = 2
)

File.open(ARGV[0], mode="rt") { |f| 

  f.each_line{ |line| 
    ReadCore.index(line)
  }
}