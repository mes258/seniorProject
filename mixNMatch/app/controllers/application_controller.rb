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
    
    def update_Profile_Score score_change
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
        @current_user[:score] = @current_user[:score] + score_change
        puts("Updated score")
        User.where(id: current_user[:id]).update_all(score: current_user[:score])
    end 
end
