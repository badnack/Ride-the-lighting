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
TRAIN_RATIO    = 0.8;
TEST_RATIO     = 0.10;
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

lines_checking = 0;
lines_test = 0;
lines_train = 0;

lines.each do |line|
  choice = rand(2)
  if choice == 0 and lines_checking < (size * CHECKING_RATIO)
    checking << line
    lines_checking += 1
  elsif (choice == 1 or lines_checking >= (size * CHECKING_RATIO)) and lines_test < (size * TEST_RATIO)
    test << line
    lines_test += 1
  elsif (choice == 2 or lines_test >= (size * TEST_RATIO)) and lines_test < (size * TRAIN_RATIO)
    train << line
    lines_train += 1
  end
end

train.close
test.close
checking.close
