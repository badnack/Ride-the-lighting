#!/usr/bin/env ruby
#
# Create an input and target matrix from given CSV
require "csv"
require "date"


# Options
trainAnfis  = "trainAnfis.csv"
testAnfis = "testAnfis.csv"
checkingAnfis = "checkingAnfis.csv"


# Costraints
TRAIN_RATIO    = 0.7;
TEST_RATIO     = 0.15;
CHECKING_RATIO = 0.15;

if ARGV.length == 0
  puts "Usage: ./anfisDivisionData DATA SOURCE FILE"
  exit
end

train    = File.open( trainAnfis, "w" )
test     = File.open( testAnfis, "w" )
checking = File.open( checkingAnfis, "w" );

average_outlight = 0
average_inlight = 0
average_energy = 0

# inputs selected before
lines = File.readlines(ARGV[0])
size = lines.size

lines_checking = lines.length * CHECKING_RATIO
lines_test = lines.length * TEST_RATIO
lines_train = lines.length * TRAIN_RATIO


for i in 1..lines_train do
  index = rand*lines.length.to_i
  train << lines[index-1]
  lines.delete_at index-1
end

for i in 1..lines_checking do
  index = rand*lines.length.to_i
   checking << lines[index-1]
  lines.delete_at index-1
end

for i in 1..lines_test do
  index = rand*lines.length.to_i
  test << lines[index-1]
  lines.delete_at index-1
end


train.close
test.close
checking.close
