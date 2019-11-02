class Profile < ApplicationRecord
  belongs_to :user

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

end
