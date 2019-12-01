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
end
