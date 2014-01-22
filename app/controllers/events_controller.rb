class EventsController < ApplicationController
  


  def index
    if params[:installation_id]
      @installation = Installation.find_by_designation(params[:installation_id])
      @events = Installation.find_by_designation(params[:installation_id]).events.page(params[:page]).per(10)
      render "installations/events/index"
    else  
      @events = Event.order("created_at DESC").page(params[:page]).per(10)
    end
  end

  def edit
   @event  = Event.find(params[:id])
  end

  def update
     @event = Event.find(params[:id])
     @installation = @event.installation
    if @event.update_attributes(params[:event])
      handle_success_edit
    else
      handle_failed_edit
    end
  end

  def handle_success_edit
    flash[:success] = "Your Comment has been added/updated"
    redirect_to events_path
  end

  def handle_failed_edit
    render 'edit'
  end  



end
