class AddLastViewedInCarouselToDisplayImage < ActiveRecord::Migration
  def change
    add_column :display_images, :last_display_in_carousel, :datetime
  end
end
