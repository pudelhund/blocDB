class ApplicationController < ActionController::Base
  	protect_from_forgery

  	helper_method :current_user
  	helper_method :unread_errors
	helper_method :unread_doubts
  	before_filter :require_login
  	before_filter :require_admin
  	before_filter :location_changed

  	private

	def current_user
	  @current_user ||= User.find(session[:user_id]) if session[:user_id]
	end

	def unread_errors
		@unread_errors = BoulderError.where('status = ?', 0).count
	end
	
	def unread_doubts
		@unread_doubts = BoulderDoubt.where('status = ? and user_id = ?', 0, current_user.id).count
	end

	def require_login
	    unless logged_in?
	      redirect_to "/", notice: 'Du musst dich einloggen!'
	    end
	end

	def require_admin
		unless logged_in?
	      redirect_to "/", notice: 'Du musst dich einloggen!'
	    end

	    unless current_user.is_admin?
	      redirect_to "/", notice: 'Dazu muss man Admin sein!'
	    end
	end

	def logged_in?
	    !!current_user
	end


	helper_method :render_tags
	def render_tags(boulder)
		tags = Array.new

		if boulder.created_at >= 1.week.ago.to_date
			tags.push('new')
		end

		if boulder.is_mod
			tags.push('mod')
		end

		output = ""
		tags.each do |tag|
			output += "<span class='tag'>"+tag+"</span>"
		end

		if request.xhr?
			respond_to do |format|
				format.html { render json: output }
			end
		else
			return output
		end
	end


	helper_method :render_points
	def render_points(boulder, show_points)

		if @event.nil?
			event_id = 0
		else
			event_id = @event.id
		end

		conquerors = boulder.boulder_conquerors.joins(:user).where("event_id = ? AND is_visible = ? AND boulder_conquerors.type != 'flash-doubt' AND boulder_conquerors.type != 'top-doubt'" , event_id, true)
		if conquerors.size == 0
			points = boulder.points
		else
			points = boulder.points / conquerors.size
		end

		if show_points == false
			output = conquerors.size.to_s
		else
			output = points.to_s + " (" + conquerors.size.to_s + ")"
		end

	end

	helper_method :render_eventlogos
	def render_eventlogos(boulder)
		html = '<span class="event-logos">'
		boulder.events.each do |event|
			if event.is_active && event.logo?
				html += '<img src="' + event.logo_url.to_s + '" width="24" height="24" title="' + event.name + '" event_id="' + event.id.to_s + '"/>'
			end
		end
		html += '</span>'
		return html
	end


	def location_changed
		logger.info('loc changed')
		if params[:lid]
			logger.info('lid')
			if logged_in?
			logger.info('logged in')
				if session[:lid] != params[:lid] 
				logger.info('change')
					self.change_location(params[:lid], current_user.id)
				end
			end
		end
	end


	public 
	def change_location(location_id, user_id)
		@user = User.find(user_id)
		if !@user.nil?	
			session[:lid] = location_id
			@user.last_visited_location_id = location_id
			@user.save
		end
	end

	public
	def get_boulder_by_location(locationID)
		boulder = Boulder.joins('INNER JOIN walls ON walls.id = COALESCE(wall_from, wall_to) ')
						 .where('status = ? AND location_id = ?', 1, locationID)
						 .order('name')
	end

	helper_method :get_active_events_by_location
	def get_active_events_by_location(locationID)
		actualEvents = Event.where('period = ? OR (period = ? AND date_from <= ? AND date_to >= ?)', false, true, Date.today, Date.today)
		events = Array.new
		actualEvents.each { |event|
			if event.get_locationID == locationID
				if not events.include? event
					events.push(event)
				end
			end
		}
		return events
	end

	helper_method :get_walls_for_location
	def get_walls_for_location(locationID)
		walls = Wall.where('location_id = ?', locationID)
		return walls;
	end
	
	helper_method :get_location
	def get_location
		if session[:lid]
			locationID = session[:lid]
		else
			if !current_user.nil? && !current_user.last_visited_location_id.nil?
				locationID = current_user.last_visited_location_id
			end 
		end
		
		if !locationID.nil?
			return Location.find(locationID)
		end
		
		return Location.first();
		
		return nil
	end

	helper_method :get_location_count
	def get_location_count
		return Location.count
	end

	helper_method :get_locationID
	def get_locationID
		location = get_location()
		if location.nil?
			return 0
		else
			return location.id
		end
	end
	
	
	helper_method :get_option_object
	def get_option_object(name, locationID = nil)
		if locationID.nil?
			locationID = get_locationID
		end
		
		unless ActiveRecord::Base.connection.table_exists? 'options'
			return nil
		end
		
		option = Option.find_by_name_and_location_id(name, locationID)
		if option.nil?
			option = Option.find_by_name_and_location_id(name, 0)
			if option.nil? 
				return nil
			end
		end
		
		return option
	end
	
	
	helper_method :get_option
	def get_option(name, locationID = nil)
		option = get_option_object(name, locationID)
		
		if option.nil?
			return nil
		end
		
		return option.value
	end
end
