#!/usr/bin/env ruby
#
# Create an input and target matrix from given CSV
require "csv"
require "date"


# Options
datapath = "data.csv"


# CSV fields position
DAY       = 0
MONTH     = 1
YEAR      = 2
HOUR      = 3
MINUTE    = 4
OUT_LIGHT = 5
IN_LIGHT  = 6
ENERGY    = 7
WORKDAY   = 8

holiday  = CSV.open( "holiday.csv", "w")


WORK_START          = 8
END_WORK            = 17
FIRST_MORNING_START = 6
FIRST_MORNING_STOP  = 9
AFTERNOON_START     = 12
NIGHT_START         = 0


ENERGY_VERY_LOW = 20

found = false
count = 0

CSV.foreach( datapath ) do |row|

  if row[WORKDAY] == 1
    next
  end
  if row[ENERGY].to_i <= ENERGY_VERY_LOW and count < 200
    count += 1
    found = true
  end
  

  if found == true    
      holiday << [row[HOUR], row[OUT_LIGHT], row[ENERGY] ]
  end

  found = false
end

holiday.close
