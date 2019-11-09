class ApplicationController < ActionController::Base
    protect_from_forgery
    helper_method :current_user
    
    private
    
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
      @profile ||= Profile.find_by(user_id: session[:user_id]) if session[:user_id]
    end
end
