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
  result = number.gsub(/\D+/,'') # remove all non-digits
  result = result.sub('1','') if result.length == 11 && result[0] == '1'

  return nil if result.length != 10
  result = result.insert(3, '-').insert(-5, '-') # insert dashes for visibility
end

def mobile_alert_report(contents, erb_template)
  names_and_phone_numbers = []
  contents.each do |row|
    name = row[:first_name]
    phone_number = clean_phone_number(row[:homephone])
    puts "#{name}: #{phone_number}"
    names_and_phone_numbers << {name: name, phone: phone_number}
  end
  # p names_and_phone_numbers
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



# ..........main..............

EM_VER = '0.1a'
puts "Event manager #{EM_VER}\n\n"

contents        = CSV.open "./event_attendees.csv", headers: true, header_converters: :symbol
template_letter = File.read "form_letter.erb"
erb_template_letter = ERB.new template_letter
# create_thank_you_letters(contents, erb_template_letter)

mobile_alert_template     = File.read "mobile_alert_template.erb"
erb_mobile_alert_template = ERB.new mobile_alert_template
mobile_alert_report(contents, erb_mobile_alert_template)
