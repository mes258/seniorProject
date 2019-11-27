class UserMatch < ApplicationRecord
    belongs_to :user
    belongs_to :match
    validates_uniqueness_of :user, scope: %i[match]
end
