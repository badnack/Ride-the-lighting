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

# time defines
HOUR_HALF = 30
HOUR_OCLOCK = 0
NIGHT_START_HOUR = 23
NIGHT_END_HOUR = 6
LOW_ENERGY = 150

input  = CSV.open( input_all, "w")
target = CSV.open( target_all, "w")

average_outlight = 0
average_inlight = 0
average_energy = 0

CSV.foreach( datapath ) do |row|

  # nights hours to skip
  if ( row[HOUR].to_i > NIGHT_START_HOUR || row[HOUR].to_i < NIGHT_END_HOUR  ) && row[ENERGY].to_i <= LOW_ENERGY + 50 
    next
  end

  # Hour averages
  if row[MINUTE].to_i == HOUR_HALF
    average_outlight = row[OUT_LIGHT].to_f
    average_inlight = row[IN_LIGHT].to_f
    average_energy = row[ENERGY].to_f
    next
  else
    average_outlight = ( average_outlight + row[OUT_LIGHT].to_f ) / 2
    average_inlight  = ( average_inlight + row[IN_LIGHT].to_f ) / 2
    average_energy = ( average_energy + row[ENERGY].to_f ) / 2
  end

  date = Date.new( row[YEAR].to_i, row[MONTH].to_i, row[DAY].to_i )
  weekday = date.cwday
  weekoftheyear = date.cweek

  input  << [ weekoftheyear, weekday, row[HOUR], average_outlight ]
  target << [ average_inlight, average_energy ]

end

input.close
target.close
