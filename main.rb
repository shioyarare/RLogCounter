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

File.open(fname, mode ="rt") { |f|
  tag = ""   # log tags
  rlogc = {} # Rails log counter
  endpoint= ""  # Endpoint

  f.each_line{ |line|

    if line == "\n" then next end

    # get current log tags
    curr_tag = line.scan(/(?<=\[).*?(?=\])/).slice(1).to_s.strip.chomp

    if curr_tag == tag then
      # extract query
      target = /(?<=\)).*?(?=\[)/.match(line).to_s.strip.chomp
      
      if target.empty? then next end
      rlogc[target] = rlogc.fetch(target, 0) + 1
      
    elsif line[0] == "I" then
      # If initial char is 'I' and log tags chenged then exist tag.
      tag = curr_tag
      endpoint = /(?<=").*?(?=")/.match(line).to_s.strip.chomp
      puts "#{endpoint}"
      puts "a"

      # Output
      res = rlogc.sort_by { |_, v| v}.reverse!
      res.each do |e|
        puts "\t<#{e[1]}> -- `#{e[0]}`"
      end

      # reset
      rlogc = {} 
    end
  }
}
