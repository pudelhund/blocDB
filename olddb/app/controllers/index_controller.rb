class IndexController < ApplicationController
	skip_before_filter :require_login
	skip_before_filter :require_admin

	def new
		# Ranking neu berechnen
		ActiveRecord::Base.connection.execute('SELECT sp_ranking();');
	
		@locations = Location.all  
		@show_location_select = false
		
		if current_user && current_user.last_visited_location_id.nil? && @locations.length > 1 && !params[:lid]
			# popup anzeigen wenn noch keine location ausgewaehlt wurde
			@show_location_select = true
		end
		@start_index = 0
		
		if current_user && !get_location.nil? && @locations.length > 1
			# wenn bereits eine location ausgewaehlt wurde, carousel start index setzen
			@location_id = get_locationID
			@start_index = 0
		end
	end
	
	def show_location_popup
		@locations = Location.all  
		render '_select_location', :layout => false
	end
end