
def interactInput() 
  rlogc      = []  # Rails log analyze
  endpoint   = ""  # Endpoint

  while line = gets
    # rails system message
    if line[0] != "I" and line[0] != "D" then
      puts line
      next
    end
    # get current log tags
    wrraped_data = line.scan(/(?<=\[).*?(?=\])/)
    if $view_logtag and wrraped_data.length > 2 then
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
      data = rlogCount(rlogc)
      writeCL(data)
      # reset
      rlogc = []
    else
      # ignore case
      if $ignore_cached and line.include?("CACHE") then
        next
      end
      target = /(?<=\)).*?(?=\[)/.match(line).to_s.strip.chomp
      if target.empty? then
        target = /(?<=\)).*?$/.match(line).to_s.strip.chomp
      end
      if target.empty? then next end
      rlogc.push( RLog.new(target, endpoint, $empty_serializer) )
    end
  end
end