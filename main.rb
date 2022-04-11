#! /usr/bin/env ruby
$stdout.sync = true

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

# Output 
def writeCL (endpoint, data, val_min=2)
  puts print "\e[31m#{endpoint}\e[0m"

  data.each do |e|
    if e[1] <= val_min then
      next
    end
    puts "\t<#{e[1]}> - `#{e[0]}`"
  end
end

File.open(fname, mode ="rt") { |f|
  tag = ""   # log tags
  rlogc = {} # Rails log counter
  endpoint= ""  # Endpoint

  f.each_line{ |line|

    # dont read, skip
    if line.include?("↳") then 
      next
    end

    # get current log tags
    curr_tag = line.scan(/(?<=\[).*?(?=\])/).slice(1).to_s.strip.chomp

    if curr_tag.empty? then next end

    if line.include?("Started GET") or line.include?("Started POST") then
      # Query start
      endpoint = /(?<=").*?(?=")/.match(line).to_s.strip.chomp
    elsif line.include?("Completed 200 OK") then
      # Query end
      
      res = rlogc.sort_by { |_, v| v}.reverse!
      writeCL(endpoint, res)

      # reset
      rlogc = {} 
    else
      # extract query
      target = /(?<=\)).*?(?=\[)/.match(line).to_s.strip.chomp
      
        if target.empty? then 
          target = /(?<=\)).*?$/.match(line).to_s.strip.chomp
        end
  
        rlogc[target] = rlogc.fetch(target, 0) + 1
    end
  }
}
