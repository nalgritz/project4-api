class Appointment < ApplicationRecord
  belongs_to :enquiry_agent
  has_one    :agent_rating
  has_one    :renter_rating
end