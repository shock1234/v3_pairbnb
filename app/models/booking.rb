class Booking < ActiveRecord::Base
  belongs_to :user
  belongs_to :listing
  validate :check_overlapping_dates
  validate :check_max_guests

  def check_overlapping_dates
    # compare this new booking againsts existing bookings
    listing.bookings.each do |old_booking|
      if overlap?(self, old_booking)
        return errors.add(:overlapping_dates, "The booking dates conflict with existing bookings") 
      end
    end
  end

  def overlap?(x,y)
    (x.start_date - y.end_date) * (y.start_date - x.end_date) > 0
  end

  def check_max_guests
    max_guests = listing.max_guests
    return if num_guests < max_guests
    errors.add(:max_guests, "Max guests number exceeded")
  end
end
