scheduler = Rufus::Scheduler.new

scheduler.every("1m") do
   MailSynch.check_email
end