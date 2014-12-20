module BouldersHelper
	
	def render_wall(boulder)
		output = ''
		if boulder.wallfrom.nil?
			unless boulder.wallto.nil?
				output = link_to boulder.wallto.name, boulder.wallto, {:class => "show", :title => boulder.wallto.name}
			end
		else
			if boulder.wallto.nil?
				output = link_to boulder.wallfrom.name, boulder.wallfrom, {:class => "show", :title => boulder.wallfrom.name}
			else
				if boulder.wallfrom.id == boulder.wallto.id
					output = link_to boulder.wallfrom.name, boulder.wallfrom, {:class => "show", :title => boulder.wallfrom.name}
				else
					output = (link_to boulder.wallfrom.name, boulder.wallfrom, {:class => "show", :title => boulder.wallfrom.name}) + " => " + (link_to boulder.wallto.name, boulder.wallto, {:class => "show", :title => boulder.wallto.name})
				end
			end
		end
		output
	end
	

	# render_captured in application_helper verlegt

	def render_comments(boulder)
		if boulder.comments.size == 0
			link_to image_tag("comments_white.png"), "/boulders/"+boulder.id.to_s+"/showcomments", {:class => "icon comments-link", :title => boulder.name}
		else
			link_to image_tag("comments.png"), "/boulders/"+boulder.id.to_s+"/showcomments", {:class => "icon comments-link", :title => boulder.name}
		end
	end
	

	def get_levels_internal(locationID = nil)
		max_level = get_option('levels_internal', locationID)

		if max_level.nil?
			max_level = '7'
		end

		levels = []
		max_level.to_i.times { |i| levels.push(i + 1) }

		return levels
	end
	

	def get_levels_external(locationID = nil)
		max_level = get_option('levels_external', locationID)

		if max_level.nil?
			max_level = '7'
		end

		levels = []
		max_level.to_i.times { |i| levels.push(i + 1) }

		return levels
	end
	

	def get_level_icon(level)
		defaultIcon = "levels/#{level}.png"
		locationIcon = "levels/#{get_locationID()}/#{level}.png"
		
		if Rails.application.assets.find_asset locationIcon
			return locationIcon
		end
		
		return defaultIcon
	end

end