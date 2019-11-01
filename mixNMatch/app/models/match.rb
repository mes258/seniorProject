class Match < ApplicationRecord
  belongs_to :profile1, :class_name => "Profile"
  belongs_to :profile2, :class_name => "Profile"
  has_many :user_matches
  has_many :users, through: :user_matches, dependent: :destroy
end
