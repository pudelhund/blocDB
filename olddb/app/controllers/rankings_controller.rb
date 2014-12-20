# encoding: utf-8
class RankingsController < ApplicationController

  skip_before_filter :require_admin

  # GET /rankings
  # GET /rankings.json
  def index

    # Ranking neu berechnen
    ActiveRecord::Base.connection.execute('SELECT sp_ranking();');
    
    @goal = "points"
    if params[:type] == "event" then
      @event = Event.find(params[:eventid])
      @goal = @event.goal;
      @order = @goal == "points" ? "points desc, flashed desc" : "conquer_count desc, flashed desc"      
	  
	  @rankings = Ranking.find(:all, :joins => :user,
                              :select => "rankings.user_id, SUM(rankings.conquer_count) as conquer_count, SUM(rankings.points) as points, SUM(rankings.flashed) as flashed, rankings.gender",
                              :group => "rankings.user_id, rankings.gender",
                              :order => @order,
                              :conditions => ["event_id = ? and user_id in (?)", params[:eventid], @event.participant_ids])
	  
      #@rankings = Ranking.where('event_id = ? AND user_id in (?)', params[:eventid], @event.participant_ids).order(@order)
      @typeText = "Event Ranking für " + @event.name
      @totalBoulders = @event.boulders.count
    end

  	if params[:type] == "points" then
      @goal = params[:type]
  	  @rankings = Ranking.all(:include => :user,
                              :conditions => ['status = 1 and users.is_visible = TRUE and event_id = 0 and location_id = ?', get_locationID()],
                              :order => 'points desc, flashed desc')
  	  @typeText = "nach Punkten";
  	  @totalBoulders = Boulder.where('status = ?', 1).count
  	end
  	if params[:type] == "amount" then
       @goal = params[:type]
  	   @rankings = Ranking.all(:include => :user,
                              :conditions => ['status = 1 and users.is_visible = TRUE and event_id = 0 and location_id = ?', get_locationID()],
                              :order => 'conquer_count desc, flashed desc')
  	   @typeText = "nach Anzahl absolvierter Routen";
  	   @totalBoulders = Boulder.where('status = ?', 1).count
  	end
  	if params[:type] == "alltime" then
       @goal = 'amount'
  	   @rankings = Ranking.find(:all, :joins => :user,
                              :select => "rankings.user_id, SUM(rankings.conquer_count) as conquer_count, SUM(rankings.points) as points, SUM(rankings.flashed) as flashed, rankings.gender",
                              :group => "rankings.user_id, rankings.gender",
                              :order => "conquer_count desc, flashed desc",
                              :conditions => ["users.is_visible = TRUE and event_id = 0 and location_id = ?", get_locationID()])
  	   @typeText = "All Time";
  	   @totalBoulders = Boulder.count
  	end

    if params[:type] != "event" then
      @rankings = @rankings.find_all{ |ranking| ranking.event == nil }
    end

    @counter = 0;

    if(!params[:gender])
      params[:gender] = 'a'
    end
    @rankings = @rankings.find_all{ |ranking| ranking.gender == params[:gender] }

    @last_rankings = Array.new;
    @last_rank;
    @rankings.map{ |ranking| 
      @counter = @counter + 1
      if params[:type] == "amount" or params[:type] == "alltime" or @goal == "amount" then 
           # Bei 100% muss ein "z" vorne ran, da sonst beim sortieren (da alphanumerisch soritert wird) die 100% am Ende stehen. Das "z" wird per JS wieder weg gemacht
           if ranking.conquer_count == @totalBoulders then ranking.groupText = "z100%" end 
           if ranking.conquer_count < @totalBoulders and ranking.conquer_count >= (0.9 * @totalBoulders) then ranking.groupText = "90%" end 
           if ranking.conquer_count < (0.9 * @totalBoulders) and ranking.conquer_count >= (0.8 * @totalBoulders) then ranking.groupText = "80%" end 
           if ranking.conquer_count < (0.8 * @totalBoulders) and ranking.conquer_count >= (0.7 * @totalBoulders) then ranking.groupText = "70%" end 
           if ranking.conquer_count < (0.7 * @totalBoulders) and ranking.conquer_count >= (0.6 * @totalBoulders) then ranking.groupText = "60%" end 
           if ranking.conquer_count < (0.6 * @totalBoulders) and ranking.conquer_count >= (0.5 * @totalBoulders) then ranking.groupText = "50%" end 
           if ranking.conquer_count < (0.5 * @totalBoulders) and ranking.conquer_count >= (0.4 * @totalBoulders) then ranking.groupText = "40%" end 
           if ranking.conquer_count < (0.4 * @totalBoulders) and ranking.conquer_count >= (0.3 * @totalBoulders) then ranking.groupText = "30%" end 
           if ranking.conquer_count < (0.3 * @totalBoulders) and ranking.conquer_count >= (0.2 * @totalBoulders) then ranking.groupText = "20%" end 
           if ranking.conquer_count < (0.2 * @totalBoulders) and ranking.conquer_count >= (0.1 * @totalBoulders) then ranking.groupText = "10%" end 
           if ranking.conquer_count < (0.1 * @totalBoulders) and ranking.conquer_count >= 0 then ranking.groupText = " < 10%" end 
      end
      if params[:type] == "points" or @goal == "points" then
        if [1, 2, 3].include?(@counter) then ranking.groupText = "TOP 3" else "-" end
      end

      @ranking_equals = false
      if @goal == 'points' then
        if @rankings[@counter] and @rankings[@counter].points == ranking.points then
          @ranking_equals = true
        end
      end
      if @goal == 'amount' then
        if @rankings[@counter] and @rankings[@counter].conquer_count == ranking.conquer_count and @rankings[@counter].flashed == ranking.flashed then
          @ranking_equals = true
        end
      end

      if @ranking_equals then
          @ranking_equals = false
          @last_rank = @counter
          @last_rankings.push(ranking)
      else
        if @last_rankings.size != 0 then
            @last_rankings.map{ |last_ranking| 
              last_ranking.rank = @last_rank + 1
            }
            @last_rankings = Array.new
        end
      end
      ranking.rank = @counter
    }

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rankings }
    end
  end
end
