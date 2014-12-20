# encoding: utf-8

module ApplicationHelper

	def render_compare_select
		if current_user.is_admin?
			@users = User.where('id != ?', current_user.id).order('username asc')
		else
			@users = User.where('is_visible = ? and id != ?', true, current_user.id).order('username asc')
		end
		select('user_compare', 'id', @users.map{|u| [u.username,u.id]}, {:prompt => 'Benutzer wählen'})
	end

  def format_date(date, format=nil)
    output = ''
    unless date.nil?
      if format.nil?
        format = "%d.%m.%Y"
      end
      output = date.to_time.strftime(format)
    end
    output
  end

  def logged_in?
      !!current_user.nil?
  end

  def is_logged_in?
      !current_user.nil?
  end

  def is_admin?
      if current_user.nil?
        false
      else
        current_user.is_admin?
      end
  end

  def cp(path)
    "active" if current_page?(path)
  end
  
  def main_nav_link(link_text, link_path, icon = '')
    class_name = link_path.include?(params[:controller]) ? 'active' : ''
    icon_class = icon + " baseline"
    content_tag(:li, :class => class_name) do
      if icon != ''
         link_to(link_path) do
           ('<i class="' + icon_class + '"></i> ' + link_text).html_safe
         end
      else
         link_to link_text, link_path
      end
    end
  end

  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.user_agent =~ /Mobile|webOS/
    end
  end

  def render_captured(boulder, compare = false, climbers = false, user_id = -1, current_user_id = -1, renderLink = true)
    
	if logged_in?
	  image_tag("lock.png", :title => "Bitte einloggen")
	else
	
		if @event.nil?
			event_id = 0
		else
			event_id = @event.id
			if !@event.is_active
				return image_tag("lock.png", :title => "Event ist abgeschlossen")
			end
			if ((!@event.participants.include? current_user) && current_user.is_admin != true)
				return image_tag("lock.png", :title => "Du nimmst nicht teil")
			end
		end
	
		if !renderLink
			if boulder.boulder_conquerors.where('event_id = ?', event_id).size == 0
				image_tag("cross.png", :id => "image_" + boulder.id.to_s + "_" + user_id.to_s)	
			else        
				if boulder.boulder_conquerors.where("user_id = ? AND event_id = ?", user_id, event_id).size == 0
					image_tag("cross.png", :id => "image_" + boulder.id.to_s + "_" + user_id.to_s)
				else
					if boulder.boulder_conquerors.where("user_id = ? AND event_id = ? AND type = ?", user_id, event_id, 'flash').size != 0
						image_tag("lightning.png", :id => "image_" + boulder.id.to_s + "_" + user_id.to_s)
					else 
						if boulder.boulder_conquerors.where("user_id = ? AND event_id = ? AND type = ?", user_id, event_id, 'top').size != 0
							image_tag("accept.png", :id => "image_" + boulder.id.to_s + "_" + user_id.to_s)
						else
							if boulder.boulder_conquerors.where("user_id = ? AND event_id = ? AND type = ?", user_id, event_id, 'flash-doubt').size != 0
								image_tag("lightning-doubt.png", :id => "image_" + boulder.id.to_s + "_" + user_id.to_s)
							else
								if boulder.boulder_conquerors.where("user_id = ? AND event_id = ? AND type = ?", user_id, event_id, 'top-doubt').size != 0
									image_tag("accept-doubt.png", :id => "image_" + boulder.id.to_s + "_" + user_id.to_s)
								end
							end
						end
					end
				end
			end
		else
		
			if current_user_id == -1
				current_user_id = current_user.id
			end
			
			ownEntry = ''
			if user_id == -1
			  user_id = current_user_id
			end
			
			if user_id.to_s == current_user_id.to_s
				ownEntry = 'true'
			end

			climbers_class_text = ''
			climbers_idtext = ''
			climbers_attr = ''
			user_idtext = ''
			if climbers
			  climbers_idtext = 'climbers_'
			  climbers_class_text = '-climbers'
			  climbers_attr = 'true'
			  user_idtext = '_' + user_id.to_s
			end
			
		  if boulder.boulder_conquerors.where('event_id = ?', event_id).size == 0
			link_to image_tag("cross.png", :id => "image_" + boulder.id.to_s + "_" + user_id.to_s), '/boulders/'+boulder.id.to_s+'/tick/top/'+event_id.to_s + '/' + user_id.to_s, {:id => 'tick_link_'+climbers_idtext+boulder.id.to_s+user_idtext, :class => "tick-link", boulder_id: boulder.id, event_id: event_id, user_id: user_id, climbers: climbers_attr, own: ownEntry }
		  else        
			if boulder.boulder_conquerors.where("user_id = ? AND event_id = ?", user_id, event_id).size == 0
			  link_to image_tag("cross.png", :id => "image_" + boulder.id.to_s + "_" + user_id.to_s), '/boulders/'+boulder.id.to_s+'/tick/top/'+event_id.to_s + '/' + user_id.to_s, {:id => 'tick_link_'+climbers_idtext+boulder.id.to_s+user_idtext, :class => "tick-link", boulder_id: boulder.id, event_id: event_id, user_id: user_id, climbers: climbers_attr, own: ownEntry}
			else
			  if boulder.boulder_conquerors.where("user_id = ? AND event_id = ? AND type = ?", user_id, event_id, 'flash').size != 0
				link_to image_tag("lightning.png", :id => "image_" + boulder.id.to_s + "_" + user_id.to_s), '/boulders/'+boulder.id.to_s+'/untick/'+event_id.to_s + '/' + user_id.to_s, {:id => 'untick_link_'+climbers_idtext+boulder.id.to_s+user_idtext, :class => "untick-link", boulder_id: boulder.id, event_id: event_id, user_id: user_id, climbers: climbers_attr, own: ownEntry}
			  else 
				if boulder.boulder_conquerors.where("user_id = ? AND event_id = ? AND type = ?", user_id, event_id, 'top').size != 0
					link_to image_tag("accept.png", :id => "image_" + boulder.id.to_s + "_" + user_id.to_s), '/boulders/'+boulder.id.to_s+'/untick/'+event_id.to_s + '/' + user_id.to_s, {:id => 'untick_link_'+climbers_idtext+boulder.id.to_s+user_idtext, :class => "untick-link", boulder_id: boulder.id, event_id: event_id, user_id: user_id, climbers: climbers_attr, own: ownEntry }
				else 
					if boulder.boulder_conquerors.where("user_id = ? AND event_id = ? AND type = ?", user_id, event_id, 'flash-doubt').size != 0
						link_to image_tag("lightning-doubt.png", :id => "image_" + boulder.id.to_s + "_" + user_id.to_s), '/boulders/'+boulder.id.to_s+'/tick/top/'+event_id.to_s + '/' + user_id.to_s, {:id => 'tick_link_'+climbers_idtext+boulder.id.to_s+user_idtext, :class => "tick-link", boulder_id: boulder.id, event_id: event_id, user_id: user_id, climbers: climbers_attr, own: ownEntry}
					else
						if boulder.boulder_conquerors.where("user_id = ? AND event_id = ? AND type = ?", user_id, event_id, 'top-doubt').size != 0
							link_to image_tag("accept-doubt.png", :id => "image_" + boulder.id.to_s + "_" + user_id.to_s), '/boulders/'+boulder.id.to_s+'/tick/top/'+event_id.to_s + '/' + user_id.to_s, {:id => 'tick_link_'+climbers_idtext+boulder.id.to_s+user_idtext, :class => "tick-link", boulder_id: boulder.id, event_id: event_id, user_id: user_id, climbers: climbers_attr, own: ownEntry}
						end
					end
				end
			  end
			end
		  end           
		end
	end
  end

  def is_doubt(boulder)
	
	if logged_in?
		return false
	else
		
		if @event.nil?
			event_id = 0
		else
			event_id = @event.id
			if !@event.is_active
			  return image_tag("lock.png", :title => "Event ist abgeschlossen")
			end
		end
	  
		if boulder.boulder_conquerors.where("user_id = ? AND event_id = ? AND (type = ? OR type = ?)", current_user.id, event_id, 'flash-doubt', 'top-doubt').size != 0
			return true;
		end
		return false;
	end
  end
  
end