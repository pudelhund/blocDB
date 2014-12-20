class EventsController < ApplicationController

  skip_before_filter :require_admin, :only=> [:index, :show, :boulders, :active, :inactive]

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
	@events = @events.find_all{ |event| event.get_locationID() == get_locationID}
	respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new
    @boulder = get_boulder_by_location(get_location())

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
    @boulder = get_boulder_by_location(get_location())
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        @event.updateParticipantTick
        format.html { redirect_to :events, notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])
    @event.updateParticipantTick

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to :events, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

  # GET /events/1/boulders
  def boulders
    @event = Event.find(params[:id])
    @is_active = @event.is_active
    @boulders = @event.boulders
    @is_participant = @event.participants.include?(current_user)

    if params[:filter] == 'event'
      @boulders = @boulders.find_all{ |boulder| boulder.events.where('events.id = ?', params[:event_id]).size == 1 }
    end

    respond_to do |format|
      format.html 
      format.json { render json: @boulders }
    end
  end


  def active
    @events = Event.all
    @events = @events.find_all{ |event| event.is_active && event.get_locationID() == get_locationID }
    render 'events/index'
  end

  def inactive
    @events = Event.all
    @events = @events.find_all{ |event| !event.is_active && event.get_locationID() == get_locationID}
    render 'events/index'
  end
end
