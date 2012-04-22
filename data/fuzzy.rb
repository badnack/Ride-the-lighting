#!/usr/bin/env ruby

require "csv"
require "date"


# Options
datapath   = "data.csv"

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
NOTTE_START = 0
PRIMA_MATTINA_START = 4
MATTINA_START = 7
POME_START = 12
SERA_START = 17

OUT_LIGHT_LOW = 200
OUT_LIGHT_MEDIUM = 500
OUT_LIGHT_HIGH = 800
OUT_LIGHT_VERY_HIGH = 1000

ENERGY_LOW = 75
ENERGY_MEDIUM = 225
ENERGY_HIGH = 375
ENERGY_VERY_HIGH = 500

IN_LIGHT_VERY_LOW = 150
IN_LIGHT_LOW = 550
IN_LIGHT_MEDIUM = 950
IN_LIGHT_HIGH = 1300


data_work = []
data_holi = []

CSV.foreach( datapath ) do |row|

  tmp = {}

  case row[HOUR].to_i
    when NOTTE_START..PRIMA_MATTINA_START
    tmp[:hour] = 'notte'

    when PRIMA_MATTINA_START..MATTINA_START
    tmp[:hour] = 'prima mattina'

    when MATTINA_START..POME_START
    tmp[:hour] = 'mattina'

    when POME_START..SERA_START
    tmp[:hour] = 'pome'

    when SERA_START..23
    tmp[:hour] = 'sera'

    else
    puts "Error!"
  end

  case row[OUT_LIGHT].to_f
    when 0..OUT_LIGHT_LOW
    tmp[:out_light] = 'basso'

    when OUT_LIGHT_LOW..OUT_LIGHT_MEDIUM
    tmp[:out_light] = 'medio'

    when OUT_LIGHT_MEDIUM..OUT_LIGHT_HIGH
    tmp[:out_light] = 'alto'

    when OUT_LIGHT_HIGH..OUT_LIGHT_VERY_HIGH
    tmp[:out_light] = 'molto alto'

    else
    puts "Error!"
  end

  case row[ENERGY].to_f
    when 0..ENERGY_LOW
    tmp[:energy] = 'basso'

    when ENERGY_LOW..ENERGY_MEDIUM
    tmp[:energy] = 'medio'

    when ENERGY_MEDIUM..ENERGY_HIGH
    tmp[:energy] = 'alto'

    when ENERGY_HIGH..ENERGY_VERY_HIGH
    tmp[:energy] = 'molto alto'
  
    else
    puts "Error!"
  end

  case row[IN_LIGHT].to_f
    when 0..IN_LIGHT_VERY_LOW
    tmp[:in_light] = 'molto bassa'

    when IN_LIGHT_VERY_LOW..IN_LIGHT_LOW
    tmp[:in_light] = 'bassa'

    when IN_LIGHT_LOW..IN_LIGHT_MEDIUM
    tmp[:in_light] = 'media'

    when IN_LIGHT_MEDIUM..IN_LIGHT_HIGH
    tmp[:in_light] = 'alta'

    else
    puts "Error!"
  end

  # Keep workday and holiday separated
  if row[WORKDAY].to_i.zero?
    data_holi << tmp
  else
    data_work << tmp
  end
end

stats = {}

stats[:fuzzy_work_energy] = data_work.inject( Hash.new(0) ) do |h,v|
  key = [ v[:hour], v[:out_light], v[:energy] ]
  h[ key ] += 1
  h
end

stats[:fuzzy_work_in_light] = data_work.inject( Hash.new(0) ) do |h,v|
  key = [ v[:hour], v[:out_light], v[:in_light] ]
  h[ key ] += 1
  h
end

stats[:fuzzy_holi_energy] = data_holi.inject( Hash.new(0) ) do |h,v|
  key = [ v[:hour], v[:out_light], v[:energy] ]
  h[ key ] += 1
  h
end

stats[:fuzzy_holi_in_light] = data_holi.inject( Hash.new(0) ) do |h,v|
  key = [ v[:hour], v[:out_light], v[:in_light] ]
  h[ key ] += 1
  h
end


# Save CSV files. Fields:
# HOUR, OUT_LIGHT, [ENERGY || IN_LIGHT], COUNT
stats.each do |name, values|
  CSV.open( "#{name}.csv", "w") do |file|
    values.each do |k,v|
      file <<  [ k[0], k[1], k[2], v ]
    end
  end
end
