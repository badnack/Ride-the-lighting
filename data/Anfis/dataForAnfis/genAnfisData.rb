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

workday  = CSV.open( "workday.csv", "w")


WORK_START          = 8
END_WORK            = 17
FIRST_MORNING_START = 6
FIRST_MORNING_STOP  = 9
AFTERNOON_START     = 12
NIGHT_START         = 0


# OUT_LIGHT_LOW = 200
# OUT_LIGHT_MEDIUM = 500
# OUT_LIGHT_HIGH = 800
# OUT_LIGHT_VERY_HIGH = 1000

ENERGY_LOW      = 125
ENERGY_VERY_LOW = 20
# ENERGY_MEDIUM = 375
# ENERGY_HIGH = 500

# IN_LIGHT_LOW = 375
# IN_LIGHT_MEDIUM = 975

count_night = 0
found = false

CSV.foreach( datapath ) do |row|

  if row[WORKDAY] == 0
    next
  end

  # work day on morning and sunny day
  # FIX ME valutare outlight
  if row[HOUR].to_i >= WORK_START and row[HOUR].to_i <= FIRST_MORNING_STOP  and row[ENERGY].to_i > ENERGY_LOW and row[ENERGY].to_i < ENERGY_LOW + 100 
    found = true
  end

  # work day on afternoon and sunny day
  #FIX valure out_light
  if row[HOUR].to_i >= AFTERNOON_START and row[HOUR].to_i < END_WORK + 1 and row[ENERGY].to_i > ENERGY_LOW and row[ENERGY].to_i < ENERGY_LOW + 50 
    found = true
  end

  # work day on night  
  if row[OUT_LIGHT].to_i <= 90 and count_night < 100 and  ( row[HOUR].to_i > NIGHT_START   or row[HOUR].to_i < FIRST_MORNING_START ) and row[ENERGY].to_i < ENERGY_VERY_LOW
    count_night += 1
    found = true
  end
  
  if found == true    
      workday << [row[HOUR], row[OUT_LIGHT], row[ENERGY] ]
  end

  found = false
end

workday.close
