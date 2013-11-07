desc "Universities Update 1 - 7th November 2013 - Add Alumni for Ox and Cam"

task :universities_update_1 => :environment do
  puts "Running university update 1"
  University.find(1).update_attribute(:domain2,"cantab.net")
  University.find(2).update_attribute(:domain2,"oxon.org")
  puts "Done."
end