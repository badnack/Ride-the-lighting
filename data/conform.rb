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

input = CSV.open( "input.csv", "w")
target = CSV.open( "target.csv", "w")

CSV.foreach( filepath ) do |row|
  date = "%02d%02d" % [ row[MONTH], row[DAY] ]
  time = "%02d%02d" % [ row[HOUR], row[MINUTE] ]

  input  << [ date, time, row[OUT_LIGHT], row[WORKDAY] ]
  target << [ row[IN_LIGHT], row[ENERGY] ]
end

input.close
target.close
