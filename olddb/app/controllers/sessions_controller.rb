class SessionsController < ApplicationController

	skip_before_filter :require_login
	skip_before_filter :require_admin

	def new
	end

	def create
	  user = User.authenticate(params[:username], params[:password])
	  if user
		session[:user_id] = user.id
		session[:user_is_admin] = user.is_admin
		session[:user_is_creator] = user.is_creator
		session[:user_is_visible] = user.is_visible
		user.last_login = Time.now
		user.save
        change_location(user.last_visited_location_id, user)
		respond_to do |format| 
			format.html { redirect_to root_url, notice: "Logged in successfully" } # render :nothing => true
		end
	  else
	  	respond_to do |format| 
			format.html { redirect_to :back, notice: "Invalid username or password" }
		end
	  end
	end

	def destroy
	  session[:user_id] = nil
	  @current_user = nil
	  respond_to do |format| 
	  	format.html { redirect_to root_url, notice: "Logged out!" }
	  end	
	end


end
