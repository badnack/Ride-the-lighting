#!/usr/bin/env ruby
#
# Create an input and target matrix from given CSV
require "csv"
require "date"


# paths
@datapath = "../conformData.csv"
@trainInlight  = "workday/trainInlight.csv"
@testInlight = "workday/testInlight.csv"
@checkingInlight = "workday/checkingInlight.csv"
@trainEnergy  = "workday/trainEnergy.csv"
@testEnergy = "workday/testEnergy.csv"
@checkingEnergy = "workday/checkingEnergy.csv"

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
WORKDAY = [ 1 , 5 ] # workdays

WORK_START          = 8
END_WORK            = 17
FIRST_MORNING_START = 6
FIRST_MORNING_STOP  = 9
AFTERNOON_START     = 12
NIGHT_START         = 0
ENERGY_LOW = 150

count = 0

def dataSplit( dataInlight, dataEnergy )

  trainInl    = CSV.open( @trainInlight, "w" )
  testInl     = CSV.open( @testInlight, "w" )
  checkingInl = CSV.open( @checkingInlight, "w" );

  trainE    = CSV.open( @trainEnergy, "w" )
  testE     = CSV.open( @testEnergy, "w" )
  checkingE = CSV.open( @checkingEnergy, "w" )


  sizeInL = dataInlight.size
  sizeE   = dataEnergy.size

  dataChecking = dataInlight.length * CHECKING_RATIO
  dataTest = dataInlight.length * TEST_RATIO
  dataTrain = dataInlight.length * TRAIN_RATIO


  # Inlight lines split
  dataTrain.to_i.times do |i|
    index = rand*dataInlight.length.to_i
    trainInl << dataInlight[index-1]
    dataInlight.delete_at index-1
  end

  dataChecking.to_i.times do |i|
    index = rand*dataInlight.length.to_i
    checkingInl << dataInlight[index-1]
    dataInlight.delete_at index-1
  end

  dataTest.to_i.times do |i|
    index = rand*dataInlight.length.to_i
    testInl << dataInlight[index-1]
    dataInlight.delete_at index-1
  end


  # energy lines split
  dataChecking = dataEnergy.length * CHECKING_RATIO
  dataTest = dataEnergy.length * TEST_RATIO
  dataTrain = dataEnergy.length * TRAIN_RATIO

  dataTrain.to_i.times do |i|
    index = rand*dataEnergy.length.to_i
    trainE << dataEnergy[index-1]
    dataEnergy.delete_at index-1
  end

  dataChecking.to_i.times do |i|
    index = rand*dataEnergy.length.to_i
    checkingE << dataEnergy[index-1]
    dataEnergy.delete_at index-1
  end

  dataTest.to_i.times do |i|
    index = rand*dataEnergy.length.to_i
    testE << dataEnergy[index-1]
    dataEnergy.delete_at index-1
  end

  trainInl.close
  testInl.close
  checkingInl.close
  trainE.close
  testE.close
  checkingE.close

end

linesInlight = Array.new
linesEnergy  = Array.new

CSV.foreach( @datapath ) do |row|

  if count < 30 && row[IN_LIGHT].to_i < 30
    count += 1
    next
  end

  if WORKDAY.include? row[DAY].to_i
    linesInlight.push [ row[HOUR], row[OUT_LIGHT], row[IN_LIGHT] ]
    linesEnergy.push [ row[HOUR], row[OUT_LIGHT], row[ENERGY] ]
  end
end

dataSplit linesInlight, linesEnergy
