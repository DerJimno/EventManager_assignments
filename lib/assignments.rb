require 'csv'
require 'time'

# 1st Assignment: Clean Phone Numbers:

def clean_number(number)
  if number.length == 10
    number
  elsif number.length == 11 && number[0] == "1"
    number[1..10]
  else
    "bad number!"
  end
end
# puts clean_number("5722397160")

num_file = CSV.open("file.csv", headers: true, header_converters: :symbol)
def number(file)
  num_arr = []
  file.each do |line|
    number = line[:phone]
    num_arr << number
  end
  num_arr.each do |num|
    puts clean_number(num)
  end
end

# number(num_file)            commented to for brevity reasons

# 2nd Assignment: Time Targeting:

file = CSV.open("file.csv", headers: true, header_converters: :symbol)

def analyze_data(file)
  hours = []
  file.each do |line|
    hours << line[:time]
  end
  hours
end

def get_hours(users_data)
  use_times = []
  users_data.each do |hour|
    result = Time.parse(hour)
    use_times << result.strftime("%k:%M:%S")
  end
  use_times
end

def most_hour(use_hours)
  use_hours.reduce(Hash.new(0)) do |result, hour|
    result[Time.parse(hour).hour] += 1
    result
  end
end 

most_use_hour = most_hour(get_hours(analyze_data(file))).max_by(3){|k,v| v}

def convert_hour(time)
 result = Time.strptime("#{time}", "%k").strftime("%H:%M")
end

def first_last(hour)
  file = CSV.open("file.csv", headers: true, header_converters: :symbol)
  all_range = []
  file.each do |line|
    if Time.parse(line[0]).hour == hour
      all_range << Time.parse(line[:time]).strftime("%H:%M:%S")
    end
  end
  all_range
end

puts "Most active hours to post ads:"
puts "- At #{convert_hour(most_use_hour[0][0])}h, there are\
 a maximum of #{most_use_hour[0][1]} people\
 registered, first: #{first_last(most_use_hour[0][0]).sort[0]} last: #{first_last(most_use_hour[0][0]).sort[-1]}"
puts "- Next at #{convert_hour(most_use_hour[1][0])}h, with\
 a maximum of #{most_use_hour[1][1]} people registered,\
 first: #{first_last(most_use_hour[1][0]).sort[0]} last: #{first_last(most_use_hour[1][0]).sort[-1]}"
puts "- Finally at #{convert_hour(most_use_hour[2][0])}h, for\
 maximum of #{most_use_hour[2][1]} people registered,\
 first: #{first_last(most_use_hour[2][0]).sort[0]} last: #{first_last(most_use_hour[2][0]).sort[-1]}"


 # 3rd Assignment: Day of the Week Targeting:

 def get_days(users_data)
  use_day = []
  users_data.each do |day|
    result = Date.parse(day)
    use_day << result.wday
  end
  use_day
end

def most_day(use_days)
  use_days.reduce(Hash.new(0)) do |result, day|
    result[Date::DAYNAMES[day]] += 1
    result
  end
end 

puts "Most active days to post ads:"

file = CSV.open("file.csv", headers: true, header_converters: :symbol)
most_use_day = most_day(get_days(analyze_data(file))).max_by(3){|k,v| v}.to_h

puts "#{most_use_day} are the days most people register!"

#=> Most active hours to post ads:
#=> - At 20:00h, there are a maximum of 8 people registered, first: 20:07:08 last: 20:37:01
#=> - Next at 07:00h, with a maximum of 5 people registered, first: 07:04:06 last: 07:48:36
#=> - Finally at 13:00h, for maximum of 4 people registered, first: 13:12:02 last: 13:40:00
#=> Most active days to post ads:
#=> {"Tuesday"=>8, "Monday"=>7, "Friday"=>6} are the days most people register!
