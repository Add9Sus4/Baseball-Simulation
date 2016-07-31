desc "This task is called by the Heroku scheduler add-on"
task :simulate_games => :environment do
  puts "Simulating games..."

  puts "done."
end
