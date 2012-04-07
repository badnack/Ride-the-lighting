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

# time define
HALF_HOUR = 30
HOUR_OCLOCK = 0
START_NIGHT_HOUR = 23
END_NIGHT_HOUR = 4

filepath = ARGV[0]

inputHoliday = CSV.open( "inputHoliday.csv", "w")
targetHoliday = CSV.open( "targetHoliday.csv", "w")

inputWork = CSV.open( "inputWork.csv", "w")
targetWork = CSV.open( "targetWork.csv", "w")

sOutLight = 0
sInLight = 0
sEnergy = 0
CSV.foreach( filepath ) do |row|

  #nights hours to jump
  if ( row[HOUR].to_i > START_NIGHT_HOUR || row[HOUR].to_i < END_NIGHT_HOUR  ) 
    next
  end

  # make averages
  if row[MINUTE].to_i == HALF_HOUR  
    sOutLight = row[OUT_LIGHT].to_f
    sInLight = row[IN_LIGHT].to_f
    sEnergy = row[ENERGY].to_f
    next
  end

  if row[MINUTE].to_i == HOUR_OCLOCK
    sOutLight = ( sOutLight + row[OUT_LIGHT].to_f ) / 2
    sInLight  = ( sInLight + row[IN_LIGHT].to_f ) / 2
    sEnergy = ( sEnergy + row[ENERGY].to_f ) / 2    
  end

  day = row[WORKDAY]

  if day == "0" then
    inputHoliday  << [ row[MONTH], row[DAY], row[HOUR], sOutLight.to_s ]
    targetHoliday << [ sInLight.to_s, sEnergy.to_s ]
  else

    inputWork  << [ row[MONTH], row[DAY], row[HOUR], sOutLight.to_s ]
    targetWork << [ sInLight.to_s, sEnergy.to_s ]
  end

end

inputHoliday.close
targetHoliday.close
inputWork.close
targetWork.close
