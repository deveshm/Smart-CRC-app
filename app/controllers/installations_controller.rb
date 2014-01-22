require 'csv'
class InstallationsController < ApplicationController
  
  before_filter :find_installation

  def index
    @installations = Installation.order('LOWER(name)').page(params[:page]).per(10)
  end

  def new
    @installation = Installation.new
    @installation.start_hour_of_concern = 7
    @installation.end_hour_of_concern = 11
  end

  def create
    @installation = Installation.new(params[:installation])
    if @installation.save
      flash[:success] = "Your installation has been saved"
      redirect_to installations_path
    else
      render 'new'
    end
  end


  def edit
  end

  def update
     @installation.next_investigation_time = nil
    if @installation.update_attributes(params[:installation])
      flash[:success] = "Your installation has been updated"
      redirect_to installations_path
    else
      render 'edit'
    end
  end
 

  def sleeping
    @installation.start_hour_of_concern = 1
    @installation.end_hour_of_concern = 2
    @installation.save
    @installation.events.each {| event| event.destroy}
    @installation.alerts.each {| alert| alert.destroy}
    redirect_to new_installation_event_path(@installation)
  end

  def checkin
    @installation.start_hour_of_concern = 1
    @installation.end_hour_of_concern =  Time.zone.now.hour+1
    @installation.save
    @installation.events.each {| event| event.destroy}
    @installation.alerts.each {| alert| alert.destroy}
    redirect_to new_installation_event_path(@installation)
  end

  def investigation
    @installation.alerts.build(alert_type: Alert::AlertType::INVESTIGATION).save!
    redirect_to new_installation_event_path(@installation)
  end

  def movement
    @installation.add_usage_event
    render :nothing => true
  end

  def usage
    csv_string = CSV.generate do | csv |
      csv << ['Installation name','Installation designation','Usage detected at','Usage duration (minutes)']
      Installation.all.each{ |installation|
        start = nil
        duration = nil
        if installation.usage_events
          installation.usage_events.each{ |usage_event|
               if usage_event.usage_event_type == UsageEvent::ON
                 start = usage_event.time
               end
               if usage_event.usage_event_type == UsageEvent::OFF
                 duration = usage_event.time - start
                 csv << [ installation.name, installation.designation, start, (duration/60).to_int]
               end
           }
        end
      }
    end
    send_data(csv_string, :type => "text/csv",:filename=>"usages-at-#{Time.zone.now}.csv",:disposition => 'attachment')
  end

  private 
  def find_installation
       @installation = Installation.find_by_designation(params[:id]) if params[:id]
  end




end
