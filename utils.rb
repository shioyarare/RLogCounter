def queryReader (line)
  type1 = /(?<=\)).*?$/.match(line).to_s
  type2 = /(?<=\)).*?(?=\[)/.match(line).to_s
  res = ""

  if type2.empty? then
    res = type1
  else
    res = type2
  end

  return res.strip.chomp
end

def endpointReader (line)
  endpoint = /(?<=").*?(?=")/.match(line).to_s
  return endpoint.strip.chomp
end

def infileReader (line)
  infile = line.scan(/(?<=↳\ ).*?(?=:)/).first
  return infile
end

def cutWrapData (line)
  return line.scan(/(?<=\[).*?(?=\])/)
end

def rlogCount (rlogd)
  # Classification by serializer
  dict = {}
  rlogd.each do |e|
    key = *e.toArr
    dict[key] = dict.fetch(key, 0) + 1
  end

  return dict
end