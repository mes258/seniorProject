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
    
    def update_score_match user
        user[:score] = user[:score] - 2
        puts("Updated score")
        User.where(id: user[:id]).update_all(score: user[:score])
        # @current_user.save
    end

    def update_score_match_accepted match_id
        match = Match.find_by(id: match_id)
        userMatches = match.user_matches
        puts("GETTING USERS")
        puts(userMatches)

        for current_user_match in userMatches
            current_u_id = current_user_match.user
            current_u = User.find_by(id: current_u_id)
            new_score = current_u.score + 5; #this  works for a static amount. Need to change to work with the profile value
            User.where(id: current_u_id).update_all(score: new_score)
        end


        # userMatch = User_Match.find_by(match: match_id)
        # users = userMatch.
    end
end
