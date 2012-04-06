#!/usr/bin/env ruby
#
# Create an input and target matrix from given CSV
require "csv"


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

filepath = ARGV[0]

inputHoliday = CSV.open( "inputHoliday.csv", "w")
targetHoliday = CSV.open( "targetHoliday.csv", "w")

inputWork = CSV.open( "inputWork.csv", "w")
targetWork = CSV.open( "targetWork.csv", "w")


CSV.foreach( filepath ) do |row|

  day = row[WORKDAY]


  if day == "0" then
    inputHoliday  << [ row[MONTH], row[DAY], row[HOUR], row[MINUTE], row[OUT_LIGHT] ]
    targetHoliday << [ row[IN_LIGHT], row[ENERGY] ]
  else
    inputWork  << [ row[MONTH], row[DAY], row[HOUR], row[MINUTE], row[OUT_LIGHT] ]
    targetWork << [ row[IN_LIGHT], row[ENERGY] ]
  end

end

inputHoliday.close
targetHoliday.close
inputWork.close
targetWork.close
