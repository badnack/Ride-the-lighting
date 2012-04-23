#!/usr/bin/env ruby
#
# Create an input and target matrix from given CSV
require "csv"
require "date"


# Options
datapath   = "original\ data/data.csv"
input_all  = "inputAll.csv"
target_all = "targetAll.csv"
new_data   = "conformData.csv"

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

NIGHT_START         = 0
EARL_MORNING_START  = 4
MORNING_START       = 7
AFTERNOON_START     = 12
EVENING_START       = 17

HOUR_HALF           = 30
HOUR_OCLOCK         = 0

OUT_LIGHT_LOW       = 200
OUT_LIGHT_MEDIUM    = 500
OUT_LIGHT_HIGH      = 800
OUT_LIGHT_VERY_HIGH = 1000

ENERGY_LOW          = 125
ENERGY_MEDIUM       = 375
ENERGY_HIGH         = 500

IN_LIGHT_LOW        = 375
IN_LIGHT_MEDIUM     = 975
IN_LIGHT_HIGH       = 1300



input  = CSV.open( input_all, "w")
target = CSV.open( target_all, "w")
newdata = CSV.open( new_data, "w")

average_outlight = 0
average_inlight = 0
average_energy = 0

def isOutlier( row )

  # outliers to remove:
  if row[WORKDAY].to_i == 1

    if ( AFTERNOON_START+1..EVENING_START).include? row[HOUR].to_i  and ( OUT_LIGHT_MEDIUM+1..OUT_LIGHT_HIGH ).include? row[OUT_LIGHT].to_i and row[ENERGY].to_i > ENERGY_MEDIUM
      return true
    end

    if ( AFTERNOON_START+1..EVENING_START).include? row[HOUR].to_i  and row[OUT_LIGHT].to_i > OUT_LIGHT_HIGH and row[ENERGY].to_i > ENERGY_MEDIUM
      return true
    end

    if ( MORNING_START+1..AFTERNOON_START ).include? row[HOUR].to_i and ( OUT_LIGHT_MEDIUM+1..OUT_LIGHT_HIGH).include? row[OUT_LIGHT].to_i  and row[IN_LIGHT].to_i < IN_LIGHT_LOW
      return true
    end

    if ( EARL_MORNING_START+1..MORNING_START ).include? row[HOUR].to_i and row[OUT_LIGHT].to_i <= OUT_LIGHT_LOW and ( IN_LIGHT_LOW+1..IN_LIGHT_MEDIUM).include? row[IN_LIGHT].to_i
      return true
    end

    if row[HOUR].to_i > EVENING_START and row[OUT_LIGHT].to_i <= OUT_LIGHT_LOW and ( IN_LIGHT_LOW+1..IN_LIGHT_MEDIUM).include? row[IN_LIGHT].to_i
      return true
    end

  end

  if row[WORKDAY].to_i == 0

    if ( AFTERNOON_START+1..EVENING_START).include? row[HOUR].to_i  and ( OUT_LIGHT_LOW+1..OUT_LIGHT_MEDIUM ).include? row[OUT_LIGHT].to_i and ( ENERGY_LOW+1..ENERGY_MEDIUM ).include? row[ENERGY].to_i
      return true
    end

    if ( MORNING_START+1..AFTERNOON_START ).include? row[HOUR].to_i and row[OUT_LIGHT].to_i > OUT_LIGHT_HIGH and row[ENERGY].to_i > ENERGY_MEDIUM
      return true
    end

    if row[HOUR].to_i > EVENING_START and row[OUT_LIGHT].to_i <= OUT_LIGHT_LOW  and ( IN_LIGHT_LOW+1..IN_LIGHT_MEDIUM).include? row[IN_LIGHT].to_i
      return true
    end

    if ( EARL_MORNING_START+1..MORNING_START ).include? row[HOUR].to_i and row[OUT_LIGHT].to_i <= OUT_LIGHT_LOW and ( IN_LIGHT_LOW+1..IN_LIGHT_MEDIUM).include? row[IN_LIGHT].to_i
      return true
    end

  end

end # end def


CSV.foreach( datapath ) do |row|

  if isOutlier( row )
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

  input   << [ weekoftheyear, weekday, row[HOUR], average_outlight ]
  target  << [ average_inlight, average_energy ]
  newdata << [ weekoftheyear, weekday, row[HOUR], average_outlight,average_inlight, average_energy ]

end

input.close
target.close
newdata.close
