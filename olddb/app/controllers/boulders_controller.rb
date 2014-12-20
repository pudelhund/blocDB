class BouldersController < ApplicationController

  skip_before_filter :require_admin, :only=> [:index, :showcomments, :show, :tick, :untick, :todo, :conquerored, :lastweek, :rate, :climbers, :report_error]

  # GET /boulders
  # GET /boulders.json
  def index
	walls = get_walls_for_location(get_location)
    @boulders = Boulder.where('status = ? and (wall_from in (?) or wall_to in (?))', 1, walls, walls).includes(:creators).includes(:events).includes(:color).includes(:wallfrom).includes(:wallto).order('level_public, created_at DESC')
    
    if params[:filter] == 'event'
      @boulders = @boulders.find_all{ |boulder| boulder.events.where('events.id = ?', params[:event_id]).size == 1 }
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @boulders }
    end
  end

  # GET /boulders/all
  # GET /boulders/all.json
  def all
	walls = get_walls_for_location(get_location)
    @boulders = Boulder.where('(wall_from in (?) or wall_to in (?))', walls, walls).includes(:creators).includes(:events).includes(:color).includes(:wallfrom).includes(:wallto).order('level_public, created_at DESC')
    if params[:filter] == 'event'
      @boulders = @boulders.find_all{ |boulder| boulder.events.where('events.id = ?', params[:event_id]).size == 1 }
    end
    render 'boulders/index'
  end

  # GET /boulders/lastweek
  # GET /boulders/lastweek.json
  def lastweek
	walls = get_walls_for_location(get_location)
    @boulders = Boulder.where('created_at >= ? AND status = ? and (wall_from in (?) or wall_to in (?))', 1.week.ago, 1, walls, walls).includes(:creators).includes(:events).includes(:color).includes(:wallfrom).includes(:wallto).order('level_public, created_at DESC')
    render 'boulders/index'
  end

  # GET /boulders/todo
  # GET /boulders/todo.json
  def todo
	walls = get_walls_for_location(get_location)
    boulders = Boulder.where('status = ? and (wall_from in (?) or wall_to in (?))', 1, walls, walls).includes(:creators).includes(:events).includes(:color).includes(:wallfrom).includes(:wallto).order('level_public, created_at DESC')
    boulders_c = Boulder.joins(:boulder_conquerors).where('status = ? AND user_id = ?', 1, current_user.id).includes(:creators).includes(:color).includes(:wallfrom).includes(:wallto).order('level_public, created_at DESC').group('boulders.id')
    @boulders = boulders - boulders_c

    if params[:filter] == 'event'
      @boulders = @boulders.find_all{ |boulder| boulder.events.where('events.id = ?', params[:event_id]).size == 1 }
    end

    render 'boulders/index'
  end

  # GET /boulders/conquerored
  # GET /boulders/conquerored.json
  def conquerored
	walls = get_walls_for_location(get_location)
    @boulders = Boulder.joins(:boulder_conquerors)
                      .where("status = ? AND user_id = ? and type != 'flash-doubt' and type != 'top-doubt' and (wall_from in (?) or wall_to in (?))", 1, current_user.id, walls, walls)
                      .includes(:creators)
                      .includes(:events)
                      .includes(:color)
                      .includes(:wallfrom)
                      .includes(:wallto)
                      .order('level_public, created_at DESC')
                      .group('boulders.id')

    if params[:filter] == 'event'
      @boulders = @boulders.find_all{ |boulder| boulder.events.where('events.id = ?', params[:event_id]).size == 1 }
    end

    render 'boulders/index'
  end

  # GET /boulders/1
  # GET /boulders/1.json
  def show
    @boulder = Boulder.find(params[:id])
    
    respond_to do |format|
      format.html { render :layout => false }# show.html.erb
      format.json { render json: @boulder }
    end
  end

  # GET /boulders/1/showcomments
  # GET /boulders/1/showcomments.json
  def showcomments
    @comments = Boulder.find(params[:id], :order => "created_at DESC").comments
    @boulder_id = params[:id]
    render 'comments/list', :layout => false
  end

  # GET /boulders/new
  # GET /boulders/new.json
  def new
    @is_new = true
    @boulder = Boulder.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @boulder }
    end
  end

  # GET /boulders/1/edit
  def edit
    @is_new = false
    @boulder = Boulder.find(params[:id])
  end

  # POST /boulders
  # POST /boulders.json
  def create
    @boulder = Boulder.new(params[:boulder])
    
    points = get_option('boulder_default_points')
    if points.nil?
    	points = 1000
    end
    
    @boulder.points = points
    
    respond_to do |format|
      if @boulder.save
        if params[:boulder_form_save_and_new]
          @boulder2 = Boulder.new
          format.html { redirect_to "/boulders/new" }
          format.json { render json: @boulder2 }
        else 
          format.html { redirect_to boulders_path, notice: 'Boulder was successfully created.' }
          format.json { render json: @boulder, status: :created, location: @boulder }
        end
      else
        format.html { render action: "new" }
        format.json { render json: @boulder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /boulders/1
  # PUT /boulders/1.json
  def update
    @boulder = Boulder.find(params[:id])
    respond_to do |format|
      if @boulder.update_attributes(params[:boulder])
        if params[:boulder_form_save_and_new]
          @boulder2 = Boulder.new
          format.html { redirect_to "/boulders/new" }
          format.json { render json: @boulder2 }
        else 
          format.html { redirect_to boulders_path, notice: 'Boulder was successfully updated.' }
          format.json { head :no_content }
        end
      else
        format.html { render action: "edit" }
        format.json { render json: @boulder.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /boulders/1/deactivate
  def deactivate
    boulder = Boulder.find(params[:id])
    boulder.deactivate
    redirect_to :boulders
  end

  # GET /boulders/1/tick/top/1
  # GET /boulders/:boulder_id/tick/top/:user_id
  def tick
    if current_user.is_admin? and params[:user_id]
      user_id = params[:user_id]
    else
      user_id = current_user.id
    end

    # Immer in allen Events in denen die Route verwendet wird abhaken und auch mit event id 0 abhaken, egal wo man abgehakt hat.
    events = Event.joins(:event_boulders).where('boulder_id = ?', params[:id])
    events.each do |event|
      if event.is_active
	  	ticked = BoulderConqueror.where({:boulder_id => params[:id], :event_id => event.id, :user_id => user_id}).first()
		if ticked
			ticked.type = params[:type]
		else
			ticked = BoulderConqueror.create({:boulder_id => params[:id], :event_id => event.id, :type => params[:type], :user_id => user_id})
		end
        ticked.save
      end
    end

	ticked = BoulderConqueror.where({:boulder_id => params[:id], :event_id => 0, :user_id => user_id}).first()
	
	if ticked
		# auch den status in der anzweifeln liste checken
		@doubt = BoulderDoubt.where("user_id = ? AND boulder_id = ?", user_id, params[:id]).first()
		if !@doubt.nil?
			@doubt.status = 1
			@doubt.save
			ticked.type = params[:type]
		end
	else
		ticked = BoulderConqueror.create({:boulder_id => params[:id], :event_id => 0, :type => params[:type], :user_id => user_id})    
	end
    ticked.save

    # LastActivity setzen
    if current_user.id.to_s == params[:user_id] or !params[:user_id]
      current_user.last_activity = Time.now
      current_user.save
    end

    # Punktezahl ermitteln und zurückgeben
    if params[:event_id] != '0'
      @event = Event.find(params[:event_id])
    end

	#### wird nicht mehr asynchron gemacht, sondern so wie früher direkt beim Aufruf des Rankings #####
	# AsyncWorker.updateRanking(logger)
    @boulder = Boulder.find(params[:id])
    respond_to do |format|
      format.html { render json: render_points(@boulder, true) }
    end

  end

  # GET /boulders/1/untick/9
  # GET /boulders/:boulder_id/untick/:user_id
  def untick

    if current_user.is_admin? and params[:user_id]
      user_id = params[:user_id]
    else
      user_id = current_user.id
    end

    # Event ID nicht beachtenm da immer alle Haken entfernt werden sollen
    BoulderConqueror.where("boulder_id = ? AND user_id = ?", params[:id], user_id).destroy_all

    # LastActivity setzen
    if current_user.id.to_s == params[:user_id] or !params[:user_id]
      current_user.last_activity = Time.now
      current_user.save
    end

    # Punktezahl ermitteln und zurückgeben
    if params[:event_id] != '0'
      @event = Event.find(params[:event_id])
	end

	#### wird nicht mehr asynchron gemacht, sondern so wie früher direkt beim Aufruf des Rankings #####
	# AsyncWorker.updateRanking(logger)
    @boulder = Boulder.find(params[:id])
    respond_to do |format|
      format.html { render json: render_points(@boulder, true) }
    end
  end

  # GET /boulders/1/togglemod
# Wurde durch die Massenbearbeitung ersetzt
#  def togglemod
#    boulder = Boulder.find(params[:id])
#    if boulder.manual_modified == nil
#      boulder.manual_modified = Time.now
#    else
#      boulder.manual_modified = nil
#    end
#    boulder.save#
#    return render_tags(boulder)
#  end

  # GET /boulders/1/rate/5
  def rate
    rating = BoulderRating.find_or_initialize_by_boulder_id_and_user_id(:boulder_id => params[:id], :user_id => current_user.id)
    rating.update_attribute(:rating, params[:rating])

    # Ranking neu berechnen
    ActiveRecord::Base.connection.execute('
      UPDATE boulders b SET rating = (SELECT (CASE WHEN COUNT(rating) > 0 THEN SUM(rating) / COUNT(rating) ELSE 0 END) as rating FROM boulder_ratings WHERE boulder_id = b.id),
                            rating_count = (SELECT COUNT(rating) as rating_count FROM boulder_ratings WHERE boulder_id = b.id);');

    boulder = Boulder.find(params[:id])

    render :text => boulder.rating
  end


  # GET /boulders/1/climbers
  def climbers
    @boulder = Boulder.find(params[:id])
	  @conquerors = BoulderConqueror.select('distinct user_id').where("boulder_id = ? AND type != 'flash-doubt' AND type != 'top-doubt'", params[:id] ).includes(:user)
    @conquerors = @conquerors.find_all{ |conqueror| conqueror.user.is_visible == true }
    #@users = User.joins(:boulders).where('boulder_id = ?', params[:id]).group('users.id').includes(:boulder_conquerors)
    render :layout => false
  end

    # GET /boulders/1/reporterror
  def report_error
    @boulder_id = params[:id]
    @boulder = Boulder.find(@boulder_id)
    @boulder_name = @boulder.name
    render '_report_error', :layout => false
  end

  # POST /boulders/massedit/:masseditaction/:boulderIDs
  def massedit
    action = params[:masseditaction]
    boulderIDs = params[:boulderIDs]
    boulderIDs = boulderIDs.split(',')
    
    message = boulderIDs.size.to_s + ' Boulder erfolgreich bearbeitet.'

    case action
      when "set_mod"
        boulderIDs.each { |id| 
          boulder = Boulder.find(id)
          boulder.set_mod
        }

      when "remove_mod"
        boulderIDs.each { |id| 
          boulder = Boulder.find(id)
          boulder.remove_mod
        }

      when "deactivate"
        boulderIDs.each { |id| 
          boulder = Boulder.find(id)
          boulder.deactivate
        }

      else
        message = "ERROR: Action " + action + " unknown!"
    end

    render :text => message
  end
end
