#!/usr/bin/env ruby
#
# Create an input and target matrix from given CSV
require "csv"
require "date"


# Options
datapath = "../conformData.csv"
inputE    = "inputInlight.csv"
targetE   = "targetInlight.csv"

# CSV fields position
WEEK      = 0
DAY       = 1
HOUR      = 2
OUT_LIGHT = 3
IN_LIGHT  = 4
ENERGY    = 5
HOLIDAY   = [ 1, 5 ]

# time defines

input  = CSV.open( inputE, "w")
target = CSV.open( targetE, "w")


CSV.foreach( datapath ) do |row|
  input << [ row[DAY], row[WEEK], row[HOUR], row[OUT_LIGHT] ]
  target << [row[IN_LIGHT]]
end

input.close
target.close
