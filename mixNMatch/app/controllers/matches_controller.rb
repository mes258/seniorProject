class MatchesController < ApplicationController
    def index
        @matches = Match.all
    end

    def new
        @match = Match.new
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
                # match exists: add user to it
                existant_match.users << current_user;
                existant_match.save
            else
                m = Match.new();
                m.profile1 = p1;
                m.profile2 = p2;
                m.save.to_s; # create match
                m.users << current_user; # add user once match id exists
                                         # otherwise errors happen (match does not exist)
                m.save.to_s; # save user-match connection
            end
            @match_status = "match was successfully created"
        else
            puts("!!   profiles are not compatible")
            @match_status = "match was not compatible"
        end
        
        respond_to do |format|
            @profiles = Profile.all
            format.html { render "profiles/index" }
        end

        #respond_to do |format|
        #    if @match.save
        #        format.html { redirect_to @match, notice: 'Match was successfully created.' }
        #        format.json { render :show, status: :created, location: @match }
        #    else
        #        format.html { render :profiles }
        #        format.json { render json: @match.errors, status: :unprocessable_entity }
        #    end
        #end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def match_params
        params.require(:match).permit(:match_id, :profile1_id, :profile2_id)
    end
end

