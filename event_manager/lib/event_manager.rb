require 'csv'
EM_VER = '0.1a'
puts "Event manager #{EM_VER}\n\n"

contents = CSV.open "./event_attendees.csv", headers: true, header_converters: :symbol
contents.each do |row|
  name = row[:first_name]
  zipcode = row[:zipcode]
  puts "#{name} #{zipcode}"
end
