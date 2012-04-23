% generate and loads anfis files
unix('cd ../data/anfis; ./holiday.rb');
unix('cd ../data/anfis; ./workday.rb');

load '../data/anfis/holiday/train.csv';
load '../data/anfis/holiday/checking.csv';
load '../data/anfis/holiday/test.csv';
load '../data/anfis/workday/trainEnergy.csv';
load '../data/anfis/workday/checkingEnergy.csv';
load '../data/anfis/workday/testEnergy.csv';
load '../data/anfis/workday/trainInlight.csv';
load '../data/anfis/workday/checkingInlight.csv';
load '../data/anfis/workday/testInlight.csv';

