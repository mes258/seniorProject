class MatchesController < ApplicationController



    def show
        @inValid = true;
        @match ||= Match.find_by(id: params[:id])
        if @match
            @profile1 ||= Profile.find_by(id: @match[:profile1_id])
            @profile2 ||= Profile.find_by(id: @match[:profile2_id])
            if @profile1 == current_user.profile || @profile2 == current_user.profile
                @inValid = false
                puts("should not be invalid")
            end
            if @profile1 == current_user.profile
                puts("should be profile2")
                @otherProfile = @profile2
            elsif @profile2 == current_user.profile
                @otherProfile = @profile1
                puts("should be profile 1")
            end
        end
    end

    def new
        @match = Match.new
    end

    # show only matches which the current user is a party of
    def index
        if(current_user.profile != nil)
            match1 = Match.all.where(profile1: current_user.profile.id)
            match2 = Match.all.where(profile2: current_user.profile.id)
        else
            match1 = []
            match2 = []
        end
        your_matches = match1 | match2
        @successful_matches = your_matches.select{|m| m.status1 == 1 and m.status2 ==1}
        @pending_response = match1.select{|m| m.status1 == 0} | match2.select{|m| m.status2 == 0}
        @your_profile = current_user.profile
    end

    def create
        if(current_user.score > 4)
            pids = []
            pids << params[:match][:profile1_id]
            pids << params[:match][:profile2_id]
            pids.sort!
            if(pids.first != "" && pids.second != "")
                p1 = Profile.find(pids.first)
                p2 = Profile.find(pids.second)

                if p1.compatible(p2)
                    puts("!!   profiles are compatible")
                    existant_match = Match.where(profile1_id: pids.first, profile2_id: pids.second).take
                    if existant_match.present?
                        # match exists: add user to it, unless they already made this match
                        if existant_match.users.include?(current_user)
                            @match_status = "you have already made this match"
                        else
                            existant_match.users << current_user;
                            update_score_match(current_user)
                            existant_match.save
                            @match_status = "match was successfully created"
                        end
                    else
                        m = Match.new();
                        m.profile1 = p1;
                        m.profile2 = p2;
                        m.status1 = 0;
                        m.status2 = 0;
                        m.save.to_s; # create match
                        m.users << current_user; # add user once match id exists
                                                # otherwise errors happen (match does not exist)
                        m.save.to_s; # save user-match connection
                        #update user score
                        update_score_match(current_user)
                        #update user details for match creation
                        @match_status = "match was successfully created"
                    end
                else
                    puts("!!   profiles are not compatible")
                    @match_status = "match was not compatible"
                end
            else
                @match_status = "You must select another user to match with"
            end
        else
            @match_status = "Sorry, your score is too low to create new matches"
        end

        respond_to do |format|
            # SET UP NEW MATCH (set vars for profiles/index)
			if(current_user.profile != nil)
		        all_profiles = Profile.where("active = ? AND id != ?", true, current_user.profile.id)
		    else
		        all_profiles = Profile.all
		    end

		    # choose a random profile to be matched
		    if all_profiles.empty?
		      @target_profile = new Profile()
		    else
		      @target_profile = all_profiles[srand % all_profiles.length]
		    end

		    # get all compatible profiles
		    @profiles = all_profiles.select{ |p| @target_profile.compatible p}
		    @current_user = current_user
            format.html { render "profiles/index" }
        end

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def match_params
        params.require(:match).permit(:match_id, :profile1_id, :profile2_id, :status1, :status2)
    end

    def update_status
        @match = Match.find(params[:match][:id])
        if @match.update(match_params)
            update_score_match_accepted(@match.id)
            # do the stuff you need to render the index
            if(current_user.profile != nil)
                match1 = Match.all.where(profile1: current_user.profile.id)
                match2 = Match.all.where(profile2: current_user.profile.id)
            else
                match1 = []
                match2 = []
            end
            your_matches = match1 | match2
            @successful_matches = your_matches.select{|m| m.status1 == 1 and m.status2 ==1}
            @pending_response = match1.select{|m| m.status1 == 0} | match2.select{|m| m.status2 == 0}
            @your_profile = current_user.profile
            render "index"
        else
            render "view"
        end
    end
end
