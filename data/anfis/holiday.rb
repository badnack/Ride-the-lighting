#!/usr/bin/env ruby
#
# Create an input and target matrix from given CSV
require "csv"
require "date"


# paths
@datapath      = "../conformData.csv"
@trainAnfis    = "holiday/train.csv"
@testAnfis     = "holiday/test.csv"
@checkingAnfis = "holiday/checking.csv"

# Costraints
TRAIN_RATIO    = 0.7;
TEST_RATIO     = 0.15;
CHECKING_RATIO = 0.15;


# CSV fields position
WEEK        = 0
DAY         = 1
HOUR        = 2
OUT_LIGHT   = 3
IN_LIGHT    = 4
ENERGY      = 5
HOLIDAY = [ 6 , 7 ] # saturday and sunday

WORK_START          = 8
END_WORK            = 17
FIRST_MORNING_START = 6
FIRST_MORNING_STOP  = 9
AFTERNOON_START     = 12
NIGHT_START         = 0
ENERGY_LOW = 150


count = 0

def dataSplit( lines, indexMaxoutlight )

  train    = CSV.open( @trainAnfis, "w" )
  test     = CSV.open( @testAnfis, "w" )
  checking = CSV.open( @checkingAnfis, "w" );

  # inputs selected before
  size = lines.size

  linesChecking = lines.length * CHECKING_RATIO
  linesTest = lines.length * TEST_RATIO
  linesTrain = lines.length * TRAIN_RATIO

  #BUG FIXED: add higher value to train set in order to avoid evalfis error
  train << lines[indexMaxoutlight]
  lines.delete_at indexMaxoutlight

  linesTrain.to_i.times do |i|
    index = rand*lines.length.to_i
    train << lines[index-1]
    lines.delete_at index-1
  end


  linesChecking.to_i.times do |i|
    index = rand*lines.length.to_i
    checking << lines[index-1]
    lines.delete_at index-1
  end

  linesTest.to_i.times do |i|
    index = rand*lines.length.to_i
    test << lines[index-1]
    lines.delete_at index-1
  end


  train.close
  test.close
  checking.close

end

lines = Array.new
maxOutlight = 0
indexMaxoutlight = -1

CSV.foreach( @datapath ) do |row|

  if count < 30 && row[IN_LIGHT].to_i < 30
    count += 1
    next
  end

  if HOLIDAY.include? row[DAY].to_i and row[IN_LIGHT].to_i < 650 # avoiding outliers and select holidays

    lines.push [ row[HOUR], row[OUT_LIGHT], row[IN_LIGHT] ]

      if row[OUT_LIGHT].to_f > maxOutlight # max outlight sample
        maxOutlight = row[OUT_LIGHT].to_f
        indexMaxoutlight = lines.length.to_i - 1
      end

  end

end

dataSplit lines, indexMaxoutlight
