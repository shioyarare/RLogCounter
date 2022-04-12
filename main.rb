#! /usr/bin/env ruby
$stdout.sync = true
$empty_serializer = " "

# flags
ignore_cached = true
view_logtag   = true

# save checked query
checked = {}

# check args
if ARGV.length <= 0 then
  puts "input filename."
  exit
end
unless File.exist?(ARGV[0]) then
  puts "No such file '#{ARGV[0]}'."
end

# open file
fname = ARGV[0]

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

def writeCL (data, val_min=2)
  ignore_count = 0
  res = {}
  keys = data.keys.sort{|a, b| a[0]<=>b[0]}
  pserializer = $empty_serializer
  pendpoint   = ""
  keys.each do |key|
    serializer = key[0]
    endpoint   = key[1]
    query      = key[2]
    count      = data[key]
    if count <= val_min then
      ignore_count += 1
      next
    end

    if pendpoint != endpoint then
      puts "\e[32m#{endpoint}\e[39m"
      pendpoint = endpoint
    end
    if pserializer != serializer then
      puts " \e[32m|-@#{serializer}@\e[39m"
      pserializer = serializer
    end
    puts " | #{count}: '#{query}'"
  end

  puts " L__ignored query is #{ignore_count} by number of calls is small"
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

File.open(fname, mode ="rt") { |f|
  rlogc      = []  # Rails log analyze
  endpoint   = ""  # Endpoint

  f.each_line{ |line|

    # get current log tags
    wrraped_data = line.scan(/(?<=\[).*?(?=\])/)
    if view_logtag and wrraped_data.length > 2 then
      curr_tag = wrraped_data[1]
    end

    # dont read, skip
    if line.include?("↳") then 
      if wrraped_data.length >= 3 and wrraped_data[2] == "active_model_serializers"
        rlogc.last.serializer = line.scan(/(?<=↳\ ).*?(?=:)/).first
      end
      next
    end

    if line.include?("Started GET") or line.include?("Started POST") then
      # Query start
      endpoint = /(?<=").*?(?=")/.match(line).to_s.strip.chomp
    elsif line.include?("Completed 200 OK") then
      # Query end

      # output once
      if checked.fetch(endpoint, false) then 
        rlogc = []
        next 
      end
      checked[endpoint] = true

      data = rlogCount(rlogc)
      writeCL(data)
      # reset
      rlogc = []
    else
      # ignore case
      if ignore_cached and line.include?("CACHE") then
        next
      end
      
      target = /(?<=\)).*?(?=\[)/.match(line).to_s.strip.chomp
      if target.empty? then
        target = /(?<=\)).*?$/.match(line).to_s.strip.chomp
      end

      if target.empty? then next end
      rlogc.push( Rlog.new(target, endpoint, $empty_serializer) )
    end
  }
}
