class MatchesController < ApplicationController
    def index
        @matches = Match.all
    end

    def new
        @match = Match.new
    end 

    def create
        @match = Match.new(match_params)

        respond_to do |format|
            if @match.save
                format.html { redirect_to @match, notice: 'Match was successfully created.' }
                format.json { render :show, status: :created, location: @match }
            else
                format.html { render :new }
                format.json { render json: @match.errors, status: :unprocessable_entity }
            end
        end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def match_params
        params.require(:match).permit(:match_id, :user, :profile1, :profile1)
    end
end

