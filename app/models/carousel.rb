class Carousel

  MINUTES_IN_DAY = 1440;


  def photo_to_display_for(installation)

    return nil if installation.messages.empty?

    span = determine_current_span_for installation

    existing_interrupt = fetch_current_interrupt_reset_if_not_current(installation, installation.messages)
    

    return add_photo_if_missing_to(existing_interrupt) if existing_interrupt

    next_undisplayed_image = fetch_and_update_next_undisplayed_image installation.messages
    

    return add_photo_if_missing_to(next_undisplayed_image) if next_undisplayed_image
    current_active_photo = fetch_current_active_photo(installation.messages, span)


    
    return add_photo_if_missing_to current_active_photo if current_active_photo

    fetch_next_active_photo_and_make_active(installation.messages, span)
  end

  def previous_photo_to_display_for(installation)

    return nil if installation.messages.empty?
    fetch_previous_active_photo(installation.messages)
  end

  def next_photo_to_display_for(installation)

    return nil if installation.messages.empty?
    fetch_next_active_photo(installation.messages)
  end

  def determine_current_span_for installation
    current_time = Time.zone.now
    minute_of_day = ((current_time.hour*60) + current_time.min)
    minutes_in_span = 1440 / installation.photo_refreshes_per_day

    start_of_span = current_time.midnight + ((minute_of_day / minutes_in_span) * minutes_in_span).minutes
    end_of_span = current_time.midnight + ((minute_of_day / minutes_in_span) * minutes_in_span).minutes + minutes_in_span.minutes
    end_of_span = end_of_span - 1.seconds
    start_of_span..end_of_span
  end

  def fetch_current_interrupt_reset_if_not_current(installation, messages)

    current_interrupt = messages.where("interrupt = ?", true).first

    if current_interrupt
      return current_interrupt if Time.zone.now < ((current_interrupt.last_display_in_carousel + installation.interrupt_duration.minutes) -1.seconds)
      current_interrupt.interrupt = false
      current_interrupt.save
    end
    nil
  end

  def fetch_and_update_next_undisplayed_image messages
    message_types_that_can_be_on_carousel = [Message::Type::EXTERNAL, Message::Type::EXTERNAL_REPLY, Message::Type::EXTERNAL_ATTACHMENT]
    undisplayed_image = messages.where("last_display_in_carousel IS NULL AND message_type IN (?)", message_types_that_can_be_on_carousel).first
    if undisplayed_image
      undisplayed_image.last_display_in_carousel = Time.zone.now
      undisplayed_image.interrupt = true
      undisplayed_image.save
    end
    undisplayed_image
  end

  def fetch_current_active_photo(messages, span)
    messages.except(:order).order("last_display_in_carousel DESC").where(:last_display_in_carousel => span).first
  end

  def fetch_next_active_photo_and_make_active(messages, span)
    active_photo_for_previous_span = messages.except(:order).order("last_display_in_carousel DESC").where("last_display_in_carousel IS NOT NULL").first
    

    active_photo = messages.except(:order).order("created_at DESC").where("(photo_file_name IS NOT NULL OR message_type = ?)AND created_at < ?", Message::Type::EXTERNAL, active_photo_for_previous_span.created_at).first
    
    active_photo = messages.except(:order).order("created_at DESC").where("photo_file_name IS NOT NULL OR message_type = ?", Message::Type::EXTERNAL).first unless active_photo
    return nil unless active_photo
    active_photo.last_display_in_carousel = Time.zone.now
    active_photo.save

    
    active_photo

  end

  def fetch_previous_active_photo(messages)
    message_types_that_can_be_on_carousel = [Message::Type::EXTERNAL, Message::Type::EXTERNAL_REPLY, Message::Type::EXTERNAL_ATTACHMENT]
    current_photo = messages.except(:order).where("last_display_in_carousel IS NOT NULL AND message_type IN (?)", message_types_that_can_be_on_carousel).order("last_display_in_carousel DESC").first
    current_photo.interrupt = false
    current_photo.save

    messages_displayable = messages.where("message_type IN (?)", message_types_that_can_be_on_carousel)

    photo = messages_displayable[(messages_displayable.index(current_photo)-1).modulo(messages_displayable.size)]

    if photo
      photo.last_display_in_carousel = Time.zone.now
      photo.save
    end
    photo

  end

  def fetch_next_active_photo(messages)

    message_types_that_can_be_on_carousel = [Message::Type::EXTERNAL, Message::Type::EXTERNAL_REPLY, Message::Type::EXTERNAL_ATTACHMENT]
    current_photo = messages.except(:order).where("last_display_in_carousel IS NOT NULL AND message_type IN (?)", message_types_that_can_be_on_carousel).order("last_display_in_carousel DESC").first
    current_photo.interrupt = false
    current_photo.save
    messages_displayable = messages.where("message_type IN (?)", message_types_that_can_be_on_carousel)

    photo = messages_displayable[(messages_displayable.index(current_photo)+1).modulo(messages_displayable.size)]
    if photo
      photo.last_display_in_carousel = Time.zone.now
      photo.save
    end
    photo
  end

  def add_photo_if_missing_to message
    unless message.photo_file_name
      prefix = message.calculate_message_prefix
      start_of_conversation = message.conversation.messages.except(:order).order("created_at").first
      message.start_of_conversation = start_of_conversation
    end
    message
  end

end