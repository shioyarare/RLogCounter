
def interactInput() 
  rlogc      = []  # Rails log analyze
  endpoint   = ""  # Endpoint
  active_serializer = false

  while line = gets
    # rails system message
    if line[0] != "I" and line[0] != "D" then
      puts line
      next
    end
    # get current log tags (no use)
    wrraped_data = cutWrapData(line)
    if $view_logtag and wrraped_data.length > 2 then
      curr_tag = wrraped_data[1]
    end

    if wrraped_data.length >= 3 and wrraped_data[2] == "active_model_serializers" then
      active_serializer = true
    else 
      active_serializer = false
    end

    # prev info
    if line.include?("↳") then 
      rlogc.last.serializer = infileReader(line)
      next
    end

    if line.include?("Started GET") or line.include?("Started POST") then
      endpoint = endpointReader(line)

    elsif line.include?("Completed 200 OK") then
      data = rlogCount(rlogc)
      writeCL(data, -1)

      rlogc = []
    else
      # ignore case
      if $ignore_cached and line.include?("CACHE") then
        next
      end

      target = queryReader(line)

      if target.empty? then next end
      rlogc.push( RLog.new(target, endpoint, $empty_serializer) )
    end
  end
end