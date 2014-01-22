class EventObserver < ActiveRecord::Observer

	def after_commit(event)
		if event.event_type == Event::EventType::HELP
			event.installation.alerts.build(alert_type: Alert::AlertType::EMERGENCY).save!
		else 
			unless event.installation.alerts.empty?
				if event.installation.alerts.first.alert_type == Alert::AlertType::EMERGENCY
					event.installation.alerts.build(alert_type: Alert::AlertType::EMERGENCY_CANCEL).save!
				elsif event.installation.alerts.first.alert_type == Alert::AlertType::INVESTIGATION
					event.installation.alerts.build(alert_type: Alert::AlertType::INVESTIGATION_CANCEL).save!
				end	
			end	 
		end	
	end

end
