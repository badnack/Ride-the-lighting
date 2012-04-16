#!/usr/bin/env ruby
#
# Create an input and target matrix from given CSV
require "csv"
require "date"


# Options
datapath   = "data.csv"
input_all  = "inputAll.csv"
target_all = "targetAll.csv"


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

input  = CSV.open( input_all, "w")
target = CSV.open( target_all, "w")

average_outlight = 0
average_inlight = 0
average_energy = 0
CSV.foreach( datapath ) do |row|

  #nights hours to skip
  if ( row[HOUR].to_i > START_NIGHT_HOUR || row[HOUR].to_i < END_NIGHT_HOUR  ) 
    next
  end

  # averages 
  if row[MINUTE].to_i == HALF_HOUR  
    average_outlight = row[OUT_LIGHT].to_f
    average_inlight = row[IN_LIGHT].to_f
    average_energy = row[ENERGY].to_f
    next
  end

  if row[MINUTE].to_i == HOUR_OCLOCK
    average_outlight = ( average_outlight + row[OUT_LIGHT].to_f ) / 2
    average_inlight  = ( average_inlight + row[IN_LIGHT].to_f ) / 2
    average_energy = ( average_energy + row[ENERGY].to_f ) / 2    
  end

  weekday = Date.new( row[YEAR].to_i, row[MONTH].to_i, row[DAY].to_i ).cwday

  input  << [ row[MONTH], weekday, row[HOUR], average_outlight.to_s ]
  target << [ average_inlight.to_s, average_energy.to_s ]
 
end

input.close
target.close
