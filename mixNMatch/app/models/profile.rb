MALE = 0
FEMALE = 1
EVERYONE = 2
NONBINARY = 2

class Profile < ApplicationRecord
  belongs_to :user
  validates :user_id, uniqueness: true
	attr_accessor :picture

	def getPicture
		return self.picture
	end

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


    # START All Possible matches:
        # male (male) to male (male)
        # male (male) to male (everyone)
        # male (male) to non-binary (male)
        # male (male) to non-binary (everyone)
        # male (female) to female (male)
        # male (female) to female (everyone)
        # male (female) to non-binary (male)
        # male (female) to non-binary (everyone)
        # male (everyone) to male (male)
        # male (everyone) to male (everyone)
        # male (everyone) to female (male)
        # male (everyone) to female (everyone)
        # male (everyone) to non-binary (male)
        # male (everyone) to non-binary (everyone)

        # female (male) to male (female)
        # female (male) to male (everyone)
        # female (male) to non-binary (female)
        # female (male) to non-binary (everyone)
        # female (female) to female (female)
        # female (female) to female (everyone)
        # female (female) to non-binary (female)
        # female (female) to non-binary (everyone)
        # female (everyone) to male (female)
        # female (everyone) to male (everyone)
        # female (everyone) to female (female)
        # female (everyone) to female (everyone)
        # female (everyone) to non-binary (female)
        # female (everyone) to non-binary (everyone)

        # non-binary (male) to male (male)
        # non-binary (male) to male (female)
        # non-binary (male) to male (everyone)
        # non-binary (female) to female (male)
        # non-binary (female) to female (female)
        # non-binary (female) to female (everyone)
        # non-binary (everyone) to male (male)
        # non-binary (everyone) to male (female)
        # non-binary (everyone) to male (everyone)
        # non-binary (everyone) to female (male)
        # non-binary (everyone) to female (female)
        # non-binary (everyone) to female (everyone)
        # non-binary (everyone) to non-binary (male)
        # non-binary (everyone) to non-binary (female)
        # non-binary (everyone) to non-binary (everyone)

    #END ALL POSSIBLE MATCHES

    # START All unique pairs:
        # Between Male and Male:
            # male (male) and male (male) DONE - prefMatch
            # male (male) and male (everyone) DONE - prefMatchEveryone
            # male (everyone) and male (everyone) DONE - prefMatchEveryone

        # Between Male and Female:
            # male (female) and female (male) DONE - prefMatch
            # male (female) and female (everyone) DONE - prefMatchEveryone
            # male (everyone) and female (male) DONE - prefMatchEveryone
            # male (everyone) and female (everyone) DONE - prefMatchEveryone

        # Between Male and Non-binary:
            # male (male) and non-binary (male) DONE - nonBinaryMatch
            # male (male) and non-binary (everyone) DONE - nonBinaryEveryone
            # male (female) and non-binary (male) DONE - nonBinaryMatch
            # male (female) and non-binary (everyone) DONE - nonBinaryEveryone
            # male (everyone) and non-binary (male) DONE - prefMatchEveryone
            # male (everyone) and non-binary (everyone) DONE - nonBinaryEveryone

        # Between Female and Female:
            # female (female) and female (female) DONE - prefMatch
            # female (female) and female (everyone) DONE - prefMatchEveryone
            # female (everyone) and female (everyone) DONE - prefMatchEveryone

        # Between Female and Non-binary:
            # female (male) and non-binary (female) DONE - nonBinaryMatch
            # female (male) and non-binary (everyone) DONE - nonBinaryEveryone
            # female (female) and non-binary (female) DONE - nonBinaryMatch
            # female (female) and non-binary (everyone) DONE - nonBinaryEveryone
            # female (everyone) and non-binary (female) DONE - prefMatchEveryone
            # female (everyone) and non-binary (everyone) DONE - nonBinaryEveryone

        #Between Non-binary and Non-binary:
            # non-binary (everyone) and non-binary (male) DONE - nonBinaryEveryone
            # non-binary (everyone) and non-binary (female) DONE - nonBinaryEveryone
            # non-binary (everyone) and non-binary (everyone) DONE - nonBinaryEveryone

    #END ALL UNIQUE PAIRS


    def compatible other_profile
        # puts "Other profile info: "
        # puts "ID: "
        # puts other_profile.id
        # puts "gender: "
        # puts other_profile.gender
        # puts "preference: "
        # puts other_profile.preference

        #make sure profiles are different
        not_same = id != other_profile.id
        #check if compatiable
        if not_same
            if nonBinaryEveryone other_profile
                return true
            elsif prefMatch other_profile
                return true
            elsif prefMatchEveryone other_profile
                return true
            elsif nonBinaryMatch other_profile
                return true
            else
                return false
            end
        end
        return not_same
    end

    def nonBinaryEveryone other_profile
        # if one of the people is Non-binary (everyone) match always works
        return gender == NONBINARY && preference == EVERYONE || other_profile.gender == NONBINARY && other_profile.preference == EVERYONE
    end

    def prefMatch other_profile
        # a (b) and b (a) where a can equal b
        return gender == other_profile.preference && preference == other_profile.gender
    end

    def prefMatchEveryone other_profile
        # a (b) and b (everyone) or a (everyone) and b (a)
        if preference == other_profile.gender && other_profile.preference == EVERYONE || preference == EVERYONE && other_profile.preference == gender
            return true
        # a (everyone) and b (everyone)
        elsif preference == EVERYONE && other_profile.preference == EVERYONE
            return true
        else
            return false
        end
    end

    def nonBinaryMatch other_profile
        # a (b) and non-binary (a)
        return preference == other_profile.gender && gender == NONBINARY || other_profile.preference == gender && other_profile.gender == NONBINARY
    end

		def getPicture
			return "https://mixnmatch-profiles.s3-us-west-2.amazonaws.com/#{pictureID}"
		end

end
