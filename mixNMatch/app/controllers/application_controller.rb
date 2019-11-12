class ApplicationController < ActionController::Base
    protect_from_forgery
    helper_method :current_user
    helper_method :profile
    
    private
    
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def profile
        @profile ||= Profile.find_by(user: session[:user_id]) if session[:user_id]
    end 
end
