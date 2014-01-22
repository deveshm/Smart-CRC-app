class Alert < ActiveRecord::Base
  attr_accessible :alert_type, :created_at,:note,:installation
  belongs_to :installation

  validates :installation_id, presence: true
  validates :alert_type, presence: true
  validates :note, length: { maximum: 1000 }
  class AlertType
  	EMERGENCY = "EMERGENCY"
  	INVESTIGATION = "INVESTIGATION"
  	INVESTIGATION_CANCEL = "INVESTIGATION_CANCEL"
    EMERGENCY_CANCEL = "EMERGENCY_CANCEL"
  end

  def self.ongoing_emergency_or_investigation(installation)
      most_recent_alert = installation.alerts.first
      if  most_recent_alert != nil  
        (AlertType::EMERGENCY == most_recent_alert.alert_type || AlertType::INVESTIGATION == most_recent_alert.alert_type) 
      else      
        false 
      end  
  end 

end
