class ReadCore
  def self.setFileReadMode()
    @@is_interactive = false
  end
  
  def self.setInteractiveMode()
    @@is_interactive = true
  end

  def self.init(is_interactive, view_logtag, ignore_cache, query_min_count)
    @@is_interactive   = is_interactive,
    @@view_logtag      = view_logtag,
    @@ignore_cache     = ignore_cache,
    @@query_min_count  = query_min_count,
    @@rlogc            = [],
    @@empty_serializer = ""
  end

  def self.index(line)
    if @@is_interactive and line[0] != "I" and line[0] != "D" then
      puts line
      return
    end

    # prev info
    if line.include?("↳") then 
      @@rlogc.last.serializer = infileReader(line)
      return
    end

    if line.include?("Started GET") or line.include?("Started POST") then
      endpoint = endpointReader(line)

    elsif line.include?("Completed 200 OK") then
      data = rlogCount(@@rlogc)
      writeCL(data, @@query_min_count)

      @@rlogc = []
    else
      # ignore case
      if @@ignore_cache and line.include?("CACHE") then
        return
      end

      target = queryReader(line)

      if target.empty? then return end
      @@rlogc.push( RLog.new(target, endpoint, @empty_serializer) )
    end
  end

end