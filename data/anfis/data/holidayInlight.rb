#!/usr/bin/env ruby
#
# Create an input and target matrix from given CSV
require "csv"
require "date"


# Options
datapath = "../../conformData.csv"


# CSV fields position
WEEK        = 0
DAY         = 1
HOUR        = 2
OUT_LIGHT   = 3
IN_LIGHT    = 4
ENERGY      = 5
HOLIDAY = [ 6 , 7 ] # saturday and sunday

holiday  = CSV.open( "holiday_inlight.csv", "w")


WORK_START          = 8
END_WORK            = 17
FIRST_MORNING_START = 6
FIRST_MORNING_STOP  = 9
AFTERNOON_START     = 12
NIGHT_START         = 0


ENERGY_LOW = 150

found = false
count = 0

CSV.foreach( datapath ) do |row|

  if count < 30 && row[IN_LIGHT].to_i < 30
    count += 1
    next
  end

  if HOLIDAY.include? row[DAY].to_i    
    if row[IN_LIGHT].to_i < 650 
      holiday << [ row[HOUR], row[OUT_LIGHT], row[IN_LIGHT] ]
    end
  end
end

holiday.close
