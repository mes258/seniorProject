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
                puts "!!   this match exists"
                puts "!!   ADD USER TO MATCH"
            else
                puts "!!   This match is new"
                puts "!!   CREATE MATCH AND ADD USER TO MATCH"
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

