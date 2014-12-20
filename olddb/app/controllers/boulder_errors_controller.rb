class BoulderErrorsController < ApplicationController

  skip_before_filter :require_admin, :only=> [:create, :togglecheck]

  # GET /boulders
  # GET /boulders.json
  def index

      @status = params[:status] ? params[:status] : "0"

      puts "STATUS: " + @status
      if @status == 'all'
        @boulder_errors = BoulderError.includes(:user).includes(:boulder).order('status, boulder_id')
      end

      if @status == "0" or @status == "1"
        puts "DRIN"
        @boulder_errors = BoulderError.where('status = ?', @status).includes(:user).includes(:boulder).order('boulder_id')
      end
      #@error_users = Hash[@boulder_errors.group_by {|x| x.user}.map {|k,v| [k,v.count]}]
      #@error_boulders = Hash[@boulder_errors.group_by {|x| x.boulder}.map {|k,v| [k,v.count]}]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @boulder_errors }
    end
  end

  # POST /boulder_errors
  # POST /boulder_errors.json
  def create
    @error = BoulderError.new
    @error.boulder_id = params[:boulder_id]
    @error.user_id = params[:user_id]
    @error.error = params[:error].encode('utf-8', 'iso-8859-1')
    @error.save

    render :nothing => true

    #respond_to do |format|
    #  if @comment.save
    #    format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
    #    format.json { render json: @comment, status: :created, location: @comment }
    #  else
    #    format.html { render action: "new" }
    #    format.json { render json: @comment.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # GET /boulder_errors/1/togglecheck
  # GET /boulder_errors/1/togglecheck.json
  def togglecheck
    boulder_error = BoulderError.find(params[:id])
    boulder_error.status = (boulder_error.status == 0) ? 1 : 0;
    boulder_error.save
    
    render :text => boulder_error.status.to_s
  end

end
