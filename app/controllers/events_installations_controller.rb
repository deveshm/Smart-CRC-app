class EventsInstallationsController < ApplicationController
  include EtagRemover
  helper_method :generate_photo_url 
  # introduce the carousel only when the following actions are performed:
  layout "carousel", :only => [:new, :create, :previous, :next]
  before_filter :find_installation

 def new
   if(@installation)
      @event = @installation.events.build

      @photo_to_display = @carousel.photo_to_display_for(@installation)
      render determine_render_target_by_installation_state(@installation) and return
   else
      redirect_to errors_installation_missing_path(invalid_designation: params[:installation_id])
   end
end

  def previous
    if(@installation)
      @event = @installation.events.build
      @photo_to_display = @carousel.previous_photo_to_display_for(@installation)
      render determine_render_target_by_installation_state(@installation) and return
    else
      redirect_to errors_installation_missing_path(invalid_designation: params[:installation_id])
    end
  end

  def next
    if(@installation)
      @event = @installation.events.build
      @photo_to_display = @carousel.next_photo_to_display_for(@installation)
      render determine_render_target_by_installation_state(@installation) and return
    else
      redirect_to errors_installation_missing_path(invalid_designation: params[:installation_id])
    end
  end

 def create
   event_type = Event::EventType::OK if params.key? :OK
   event_type ||= Event::EventType::HELP
   flash[:error] = "An emergency message has been posted" if event_type == Event::EventType::HELP

   @event = @installation.create_event(event_type)
   
   human_readable_event_type  = case event_type
                                when Event::EventType::OK then "OK notification"
                                when Event::EventType::HELP then "Help Request"
                                end

    flash[:error] = "Your #{human_readable_event_type} has failed to be processsed ,please try again" unless @event
    redirect_to new_installation_event_path(@installation)
  end

  def determine_render_target_by_installation_state(installation)
    case installation.state
      when Installation::State::ONGOING_EMERGENCY
        "events/ongoing_investigation"  
      when Installation::State::ONGOING_INVESTIGATION
        "events/ongoing_investigation"  
      when Installation::State::REQUIRE_CHECKIN
        "events/require_checkin"
      else
        "events/sleeping"
    end
  end

  def index
    @events = @events.page(params[:page]).per(10)
    render "installations/events/index"
  end

  def edit
    @event  = Event.find(params[:id])
    render 'installations/events/edit'
  end

  def update
     @event = Event.find(params[:id])
    if @event.update_attributes(params[:event])
      handle_success_edit
    else
      handle_failed_edit
    end
  end

  def handle_success_edit
      flash[:success] = "Your Comment has been added/updated"   
      redirect_to installation_events_path(@event.installation)
  end

  def handle_failed_edit 
      render 'installations/events/edit'
  end


  def generate_photo_url
  puts "current installation state is: " + @installation.state
  case @installation.state
    when Installation::State::ONGOING_INVESTIGATION
      #if photo_file_name exists, return photo to display, else return the photo from the start of convo
      investigation_message_path @photo_to_display.photo_file_name ? @photo_to_display : @photo_to_display.start_of_conversation     
    else
      #here we are generating the url for the photo

      # THIS IS RETURNING THE DFAULT MESSAGE PATH "/messages/[:id]/default"
      # oh i think once the photo is stored on s3, you can access it using its name
      puts "in generate_photo_url " + (default_message_path @photo_to_display.photo_file_name ? @photo_to_display : @photo_to_display.start_of_conversation)
      default_message_path @photo_to_display.photo_file_name ? @photo_to_display : @photo_to_display.start_of_conversation
    end
  end
 

  def initialize(*params)
    super(*params)

    @carousel = Carousel.new
end

  private 
  def find_installation
       @installation = Installation.find_by_designation(params[:installation_id]) if params[:installation_id]
       @events = @installation ? @installation.events : Event.order('created_at DESC')
  end

end