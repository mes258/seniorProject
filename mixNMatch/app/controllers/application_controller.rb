class ApplicationController < ActionController::Base
    protect_from_forgery
    helper_method :current_user
    helper_method :profile
    helper_method :update_Profile_Score
    
    private
    
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def profile
        @profile ||= Profile.find_by(user: session[:user_id]) if session[:user_id]
    end 
    
    #update a user score when the match is made
    def update_score_match user
        user[:score] = user[:score] - 5
        User.where(id: user[:id]).update_all(score: user[:score])
    end

    #Update the user score when a match is accepted. 
    def update_score_match_accepted match_id
        match = Match.find_by(id: match_id)
        scoreChange = 0
        if(match.status1 == 1 && match.status2 == 1)
            scoreChange = 20
        elsif(match.status1 == 1 || match.status2 == 1)
            scoreChange = 5
        end

        userMatches = match.user_matches
        puts(userMatches)

        for current_user_match in userMatches
            current_u_id = current_user_match.user
            current_u = User.find_by(id: current_u_id)
            new_score = current_u.score + scoreChange
            User.where(id: current_u_id).update_all(score: new_score)
        end
        


        # userMatch = User_Match.find_by(match: match_id)
        # users = userMatch.
    end
end
