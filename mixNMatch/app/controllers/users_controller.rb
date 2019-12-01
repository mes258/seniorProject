class UsersController < ApplicationController
    
    def show
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
        @profile ||= Profile.find_by(user: session[:user_id]) if session[:user_id]
    end 

    def new
        @user = User.new
    end
  
    def create
        @user = User.new(user_params)

        if @user.save
            @user[:email] = user_params[:email]
            @user[:score] = 50;
            @user.save
            redirect_to root_url, :notice => "Signed up!"
        else
            render "new"
        end
    end

    private 
    def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
    end 
end
