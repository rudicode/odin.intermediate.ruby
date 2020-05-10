require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5,"0").slice(0,5)
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'  #jumpstartlab key

  begin
    civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
    rescue
      "You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials"
    end

end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir("output") unless Dir.exists? "output"
  filename = "output/thanks_#{id}.html"
  File.open(filename,'w') do |file|
    file.puts form_letter
  end
end

def create_thank_you_letters(contents, erb_template)
  contents.each do |row|
    id = row[0]
    name = row[:first_name]
    zipcode = clean_zipcode(row[:zipcode])
    legislators = legislators_by_zipcode(zipcode)
    form_letter = erb_template.result(binding)
    save_thank_you_letter(id, form_letter)
  end

end

def clean_phone_number(number)
  # validates phone numbers and discards invalid ones.
  result = number.gsub(/\D+/,'') # remove all non-digits
  result = result.sub('1','') if result.length == 11 && result[0] == '1'

  return nil if result.length != 10
  result = result.insert(3, '-').insert(-5, '-') # insert dashes for visibility
end

def mobile_alert_report(contents, erb_template)
  # creates report with name and telephone number of each signed up person
  names_and_phone_numbers = []
  contents.each do |row|
    name = row[:first_name]
    phone_number = clean_phone_number(row[:homephone])
    names_and_phone_numbers << {name: name, phone: phone_number}
  end
  report = erb_template.result(binding)
  save_mobile_alert_report(report)
end

def save_mobile_alert_report(report)
  Dir.mkdir("output") unless Dir.exists? "output"
  filename = "output/mobile_alert_report.html"
  File.open(filename,'w') do |file|
    file.puts report
  end
end

def parse_dates(contents)
  hour_arr = Array.new(24,0)
  day_arr = Array.new(7,0)
  contents.each do |row|
    date = DateTime.strptime(row[:regdate], '%m/%d/%y %H:%M')
    hour_arr[date.hour] += 1
    day_arr[date.wday] += 1
  end
  [hour_arr, day_arr]
end

# ..........main..............

EM_VER = '0.1a'
puts "Event manager #{EM_VER}\n\n"

contents = CSV.open "./event_attendees.csv", headers: true, header_converters: :symbol
template_letter = File.read "form_letter.erb"
erb_template_letter = ERB.new template_letter
# below line will create one html file per data line of the csv file
# comment it out for large data set in "event_attendees_full.csv"
# create_thank_you_letters(contents, erb_template_letter)

mobile_alert_template = File.read "mobile_alert_template.erb"
erb_mobile_alert_template = ERB.new mobile_alert_template
contents.rewind
mobile_alert_report(contents, erb_mobile_alert_template)

contents.rewind
hours_arr, day_arr = parse_dates(contents)

graph_max_width = 100.0
graph_multiplier = hours_arr.max / graph_max_width
graph_multiplier = 1 if graph_multiplier < 1

puts "\n\nSignup Frequency - Hourly \n\n"
puts "Hour     #   Scale * = #{graph_multiplier.round} sign ups."

hours_arr.each_with_index do |num_of_signups, index|
  print "#{index.to_s.rjust(4," ")}: #{num_of_signups.to_s.rjust(4," ")}  |"
  puts "*" * (num_of_signups / graph_multiplier)
end

WEEKDAYS = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
graph_max_width = 100.0
graph_multiplier = day_arr.max / graph_max_width
graph_multiplier = 1 if graph_multiplier < 1

puts "\n\nSignup Frequency - Days of the Week\n\n"
puts "        Day      #   Scale * = #{graph_multiplier.round} sign ups."

WEEKDAYS.each_with_index do |day, index|
  num_of_signups = day_arr[index]
  day_name = day.rjust(11," ")
  print "#{day_name}: #{num_of_signups.to_s.rjust(5," ")}  |"
  puts "*" * (num_of_signups / graph_multiplier)
end
