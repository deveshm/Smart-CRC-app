module EventAnalyzer
 
	def self.createAlerts
	 	timeToActivate = Time.zone.now + 1.minutes
	 	Installation.all.each do |install|
	 		puts "Checking installation " + install.designation
	 		# puts "Their time range is: " + install.current_active_time_range.to_s
	 		investigate_install install if install.next_investigation_time < timeToActivate
	 	end
	 	#Installation.where("next_investigation_time < ?",timeToActivate).each do | installation|
	 	#	investigate_install installation
	 	#end
	end	

	def self.investigate_install(installation)
	    time_range =  installation.current_active_time_range	
	    if !Alert.ongoing_emergency_or_investigation(installation) && Event.no_event_within(time_range,installation)
			puts "Creating alert for " + installation.designation
			installation.alerts.build(alert_type: Alert::AlertType::INVESTIGATION).save!
		end
		# puts "install current investigation time: " + installation.next_investigation_time.to_s
	    installation.roll_investigation_time!
	    # puts "install rolled investigation time: " + installation.next_investigation_time.to_s
	end


end