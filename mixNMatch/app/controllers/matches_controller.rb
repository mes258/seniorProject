class MatchesController < ApplicationController
    def index
        match1 = Match.all.where(profile1: current_user.profile.id)
        match2 = Match.all.where(profile2: current_user.profile.id)
        @matches = match1 | match2
    end

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
        @matches = Match.where("profile1_id = ? OR profile2_id = ?", current_user.profile.id, current_user.profile.id)
        @your_profile = current_user.profile
    end

    def create
        
        pids = []
        pids << params[:match][:profile1_id]
        pids << params[:match][:profile2_id]
        pids.sort!
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
                update_Profile_Score(-2)
                #update user details for match creation
                @match_status = "match was successfully created"
            end
        else
            puts("!!   profiles are not compatible")
            @match_status = "match was not compatible"
        end
        
        respond_to do |format|
            @profiles = Profile.all
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
            @matches = Match.where("profile1_id = ? OR profile2_id = ?", current_user.profile.id, current_user.profile.id)
            @your_profile = current_user.profile
            render "index"
        else
            render "view"
        end
    end
end

