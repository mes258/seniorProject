class Profile < ApplicationRecord
  belongs_to :user
  validates :user_id, uniqueness: true

	def self.preferenceMap(val)
		case val
		when 0
			"Male"
		when 1
			"Female"
		when 2
			"Everyone"
		else
			"Not set"
		end
	end

	def self.genderMap(val)
		case val
		when 0
			"Male"
		when 1
			"Female"
		when 2
			"Non-binary"
		else
			"Not set"
		end
	end

	def fullName
		"#{first} #{last}"
    end
    
 
        # Possible matches: 
        # male (male) to male (male)
        # male (male) to male (everyone)
        # male (female) to female (male)
        # male (female) to female (everyone)
        # male (everyone) to male (everyone)
        # male (everyone) to female (everyone)
        # male (everyone) to non-binary (male)
        # male (everyone) to non-binary (everyone)

        # female (male) to male (female)
        # female (male) to male (everyone)
        # female (female) to female (female)
        # female (female) to female (everyone)
        # female (everyone) to male (everyone)
        # female (everyone) to female (everyone)
        # female (everyone) to non-binary (female)
        # female (everyone) to non-binary (everyone)

        # non-binary (male) to male (everyone)
        # non-binary (female) to female (everyone)
        # non-binary (everyone) to male (everyone)
        # non-binary (everyone) to female (everyone)
        # non-binary (everyone) to non-binary (everyone)


    def compatible other_profile
        #make sure profiles are different
        not_same = id != other_profile.id
        #check if compatiable 
        if not_same
            can_match = gender == other_profile.preference
        end
        if can_match
            can_match = preference == other_profile.gender
        end
        #if match is male to male, male to female, female to male, or female to female, it's a match.
        if can_match
            return can_match
        end

        

        

        
		return not_same
	end

end
