class UsersController < ApplicationController

  skip_before_filter :require_login, :only=> [:register, :create, :compareto]
  skip_before_filter :require_admin, :only=> [:register, :create, :update, :chgpassword, :edit, :compareto, :report_doubt, :save_location_preference]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
    @user.update_password = true

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    # Sichergehen dass nur der Admin andere Profile bearbeitet
    if current_user.is_admin?
      @user = User.find(params[:id])
    else 
      if current_user.id.to_s == params[:id]
        @user = User.find(params[:id])
      else 
        redirect_to :users
      end
    end
    
  end
  
  # POST /users/:user_id/saveLocationPreference/:location_id
  def save_location_preference
	change_location(params[:location_id], params[:user_id])
	
	render :nothing => true
  end


  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    @user.update_password = true

    respond_to do |format|
      if @user.save
        format.html { redirect_to :users, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update

    # Sichergehen dass nur der Admin andere Profile bearbeitet
    if current_user.is_admin?
      @user = User.find(params[:id])
    else 
      if current_user.id.to_s == params[:id]
        @user = User.find(params[:id])
      else 
        redirect_to :users
      end
    end

    @user.update_password = false
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to '/', notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  # GET /users/register
  # GET /users/register
  def register     
    @user = User.new
    @user.update_password = true
  end

  # GET /users/1/resetpassword
  # GET /users/1/resetpassword
  def resetpassword
    @user = User.find(params[:id])
    @user.update_password = false
    @user.password = "59c367b2dc530d0fbb5916d97efbce97"  #routen
    @user.password_confirmation = "59c367b2dc530d0fbb5916d97efbce97"   #routen
    @user.save
    render :nothing => true
  end

  # GET /users/1/chgpassword
  def chgpassword
    @user = User.find(params[:id])
    @user.update_password = true

    respond_to do |format|
      if params[:user] && @user.update_attributes(params[:user])
        format.html { redirect_to '/', notice: 'Password changed.' }
        format.json { head :no_content }
      else
        format.html { render action: "chgpassword" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /users/1/compareto/2
  def compareto
    # eventuell nach EventId filtern ?
	walls = get_walls_for_location(get_location)
    @boulder_conquerors = BoulderConqueror.find(:all, :include => [:user], :joins => :boulder,
                                                :order => "boulder_id asc",
                                                :conditions => ["user_id in (" + params[:id] + "," + params[:compare_id] + ") AND event_id = 0 and boulders.status = 1 "])
											
	
												
    @conquers = Array.new
    @user1 = User.find(params[:id])
    @user2 = User.find(params[:compare_id])
    i = 0
    while i < @boulder_conquerors.length
      conqueror = @boulder_conquerors[i]
		if !(walls.include? conqueror.boulder.wallfrom or walls.include? conqueror.boulder.wallto)
			i = i+1
			next
		end
		
      if !@boulder_conquerors[i+1].nil? && @boulder_conquerors[i+1].boulder.id == conqueror.boulder.id
        if(conqueror.user.id == @user2.id)
          @conquers.push(Hash[:boulder => conqueror.boulder, :user1 => @boulder_conquerors[i+1].user, :user2 => conqueror.user, :conquer_type1 => @boulder_conquerors[i+1].type, :conquer_type2 => conqueror.type])
        else
          @conquers.push(Hash[:boulder => conqueror.boulder, :user1 => conqueror.user, :user2 => @boulder_conquerors[i+1].user, :conquer_type1 => conqueror.type, :conquer_type2 => @boulder_conquerors[i+1].type])
        end
        i += 2
      else
        if(conqueror.user.id === @user2.id)
          @conquers.push(Hash[:boulder => conqueror.boulder, :user1 => nil, :user2 => conqueror.user, :conquer_type1 => nil, :conquer_type2 => conqueror.type])
        else
          @conquers.push(Hash[:boulder => conqueror.boulder, :user1 => conqueror.user, :user2 => nil, :conquer_type1 => conqueror.type, :conquer_type2 => nil])
        end
        i += 1
      end
    end
  end
  
      # GET /user/1/reportdoubt/15
  def report_doubt
	@user = User.find(params[:id])
    @boulder = Boulder.find(params[:boulderid])
    render '_report_doubt', :layout => false
  end
end
