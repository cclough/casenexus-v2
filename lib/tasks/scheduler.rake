desc "Heroku Scheduler Task - Event Reminders"

task :send_event_reminders => :environment do
  puts "Sending event reminders..."
  Event.send_reminders
  puts "Done."
end