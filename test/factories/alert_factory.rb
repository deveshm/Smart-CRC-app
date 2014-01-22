FactoryGirl.define do


  factory :alert do

  	factory :investigation_alert  do   
     alert_type Alert::AlertType::INVESTIGATION

    end  
  end


end