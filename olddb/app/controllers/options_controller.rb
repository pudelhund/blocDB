class OptionsController < ApplicationController

	@@myOptions = [
		"boulder_default_points", 
		"levels_internal",
		"levels_external"
	]


	def index

		@options = @@myOptions

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @options }
		end
	end


	def save
		values = params[:values]
		
		values.each do |key,value|			
			option = get_option_object(key)
			unless option.nil?
				option.value = value
				option.location_id = get_locationID()
				option.save
			else
				option = Option.new
				option.name = key
				option.value = value
				option.location_id = get_locationID()
				option.save
			end
		end
		
		redirect_to '/options'
	end


end
