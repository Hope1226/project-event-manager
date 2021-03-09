=begin #below algorythm is written to put the first names of attendees 
puts "Event manager initialized!"

lines = File.readlines('event_attendees.csv')
lines.each_with_index do |line, index|
  next if index == 0
  arr = line.split(",")
  names = arr[2]

  puts names
end

# next will use libery to do the same thing
 
=end 

require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

puts "Event manager initialized!"




def clean_code(zip)
    zip.to_s.rjust(5, '0')[0..4]
=begin  if zip.nil?
        zip = "00000"
    elsif zip.length < 5
        zip = zip.rjust(5, '0')
    elsif zip.length > 5
        zip = zip[0..4]
    else
        zip = zip
    end 
=end

end 

def legistlators_by_zip(zip)
 civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
 civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'
  
 begin
    civic_info.representative_info_by_address(
     address: zip,
     levels: 'country',
     roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
 rescue 
    "You can find your representative by visiting www.commoncause.org/take-action/find-elected-officials"
 end 
end 

def save_thanks_letter(id, letter_form)
    Dir.mkdir('output')unless Dir.exist?('output')
    filename = "output/thanks_#{id}.html"

    File.open(filename, 'w'){|file| file.puts letter_form}
end

letter_template = File.read('form_letter.erb')
erb_template = ERB.new letter_template

contents = CSV.open(
    'event_attendees.csv', 
    headers: true,
    header_converters: :symbol
)

contents.each do |row|
    name = row[:first_name]
    zip_code = row[:zipcode]
    att_id = row[0]
    clean_zip = clean_code(zip_code)
    legislators = legistlators_by_zip(clean_zip)
    form_letter = erb_template.result(binding)
    save_thanks_letter(att_id, form_letter)

    
end 




