class Match < ApplicationRecord
  belongs_to :profile1, :class_name => "Profile"
  belongs_to :profile2, :class_name => "Profile"
end
