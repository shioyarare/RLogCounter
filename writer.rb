def writeCL (data, val_min=2)
  ignore_count = 0
  res = {}
  keys = data.keys.sort{|a, b| a[0]<=>b[0]}
  pserializer = ""
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
      puts "\e[32m[#{endpoint}]\e[39m"
      pendpoint = endpoint
    end
    if pserializer != serializer then
      puts " \e[32m|-@#{serializer}@\e[39m"
      pserializer = serializer
    end
    puts " | #{count}: '#{query}'"
  end

  puts " L__ignored query is #{ignore_count} by number of calls is small (<= #{val_min})"
end