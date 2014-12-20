class BoulderDoubtsController < ApplicationController

	skip_before_filter :require_admin, :only=> [:index, :create, :togglecheck]
	
  # GET /boulder_doubts
  # GET /boulder_doubts.json
  def index

      @status = params[:status] ? params[:status] : "0"

      if @status == 'all'
        @boulder_doubts = BoulderDoubt.where('user_id = ?', current_user.id).includes(:user).includes(:boulder).order('status, boulder_id')
      end

      if @status == "0" or @status == "1"
        @boulder_doubts = BoulderDoubt.where('status = ? and user_id = ?', @status, current_user.id).includes(:user).includes(:boulder).order('boulder_id')
      end
	  
      #@error_users = Hash[@boulder_errors.group_by {|x| x.user}.map {|k,v| [k,v.count]}]
      #@error_boulders = Hash[@boulder_errors.group_by {|x| x.boulder}.map {|k,v| [k,v.count]}]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @boulder_doubts }
    end
  end

  # POST /boulder_errors
  # POST /boulder_errors.json
  def create
	if(current_user)
		# check, ob user boulder/user bereits angezweifelt hat
		@doubt = BoulderDoubt.where('boulder_id = ? and user_id = ? and author_id = ?', params[:boulder_id], params[:user_id], current_user.id)
		
		if(@doubt.length == 0)
			@doubt = BoulderDoubt.new
		else
			@doubt = @doubt[0];
		end
		
		@doubt.boulder_id = params[:boulder_id]
		@doubt.user_id = params[:user_id]
		@doubt.author_id = current_user.id
		@doubt.description = params[:description].encode('utf-8', 'iso-8859-1')
		@doubt.status = 0
		@doubt.save
		
		# Begehung (auch in allen Evenets) auf flash-doubt oder top-doubt setzen, sodass Sie in Ranking nicht mehr verwendet wird
		conquers = BoulderConqueror.where("boulder_id = ? AND user_id = ?", params[:boulder_id], params[:user_id])
		
		conquers.each do |conquer|
			if conquer.type == 'top'
				conquer.type = 'top-doubt'
			end
			if conquer.type == 'flash'
				conquer.type = 'flash-doubt'
			end
			conquer.save
		end
	end

    #render :nothing => true
	
	
    # Punktezahl ermitteln und zurückgeben
    @boulder = Boulder.find(params[:boulder_id])
    respond_to do |format|
      format.html { render json: render_points(@boulder, true) } 
    end
  end

  # GET /boulder_doubts/1/togglecheck
  # GET /boulder_doubts/1/togglecheck.json
  def togglecheck
    boulder_doubt = BoulderDoubt.find(params[:id])
    boulder_doubt.status = (boulder_doubt.status == 0) ? 1 : 0;
    boulder_doubt.save
    
    render :text => boulder_doubt.status.to_s
  end
end
