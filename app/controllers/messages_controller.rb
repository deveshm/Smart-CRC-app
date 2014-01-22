require 'timeout'

class MessagesController < ApplicationController 
  
  helper_method :url_of_photo
  before_filter :find_message

 def default
      #WE ARE GETTING A TIME OUT ERROR HERE
      #puts "This is the joined message url: " + @message.retrive_url(request.original_url,:original).inspect

      begin
        data = open( @message.retrive_url(request.original_url,:original))
        rescue OpenURI::HTTPError => the_error
        # some clean up work goes here and then..
        the_status = the_error.io.status[0] # => 3xx, 4xx, or 5xx
        # the_error.message is the numeric code and text in a string
        puts "Whoops got a bad status code #{the_error.message}"
      end
      
      response.headers["Expires"] = 10.years.from_now.httpdate
      response.headers["Cache-Control"] = "max-age=31536000"
      expires_in 5.years
      response.etag = nil
      send_data(data.read ,  type: @message.photo_content_type,  filename: "sample")
  end

  def url_of_photo
    @message.retrive_url(request.original_url,:original)
  end

  def checkin
      #HTTP response details
      response.headers["Expires"] = 10.years.from_now.httpdate
      response.headers["Cache-Control"] = "max-age=31536000"
      expires_in 5.years
      response.etag = nil
      send_data(@message.merge_image(request.url,'checkin_overlay.png') ,  type: @message.photo_content_type,  filename: "sample")
  end

  def investigation
    response.headers["Expires"] = 10.years.from_now.httpdate
    response.headers["Cache-Control"] = "max-age=31536000"
    expires_in 5.years
    response.etag = nil
    send_data(@message.merge_image(request.url,'investigation_overlay.png') ,  type: @message.photo_content_type,  filename: "sample")
  end

  private 
  def find_message
       @message = Message.find(params[:id])
  end

end