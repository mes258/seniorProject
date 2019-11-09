class Profile < ApplicationRecord
  belongs_to :user
  validates :user_id, uniqueness: true

	def self.preferenceMap(val)
		case val
		when 0
			"Straight"
		when 1
			"Gay"
		when 2
			"Bisexual"
		when 3
			"Pansexual"
		else
			"Not set"
		end
	end

	def self.genderMap(val)
		case val
		when 0
			"He/Him/His"
		when 1
			"She/Her/Hers"
		when 2
			"They/Them/Theirs"
		else
			"Not set"
		end
	end

	def fullName
		"#{first} #{last}"
	end

	def compatible other_profile
		not_same = id != other_profile.id
		#list other requirements here
		return not_same
	end

end
