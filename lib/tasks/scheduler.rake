
desc "This task is called by the Heroku scheduler add-on"

task :check_for_investigations => :environment do
  puts "Checking for investigation alerts..."
  EventAnalyzer.createAlerts
  puts "have finished Investigation alert"
end

task :check_for_emails => :environment do
  puts "Checking for mail attachments..."
  MailSynch.check_email
  puts "Checking for mail attachments..."
end