module IndexHelper

	def boulderCount(status, locationID)
		return Boulder.joins('INNER JOIN walls ON walls.id = COALESCE(wall_from, wall_to) ')
						.where('status = ? AND location_id = ?', status, locationID)
						.count		
	end	



	def wallCount(locationID)
		return Wall.where('location_id = ?', locationID).count
	end



	def newRoutesSinceLastLogin(locationID)

	end



	def newRoutesSinceLastWeek(locationID)
		return Boulder.joins('INNER JOIN walls ON walls.id = COALESCE(wall_from, wall_to) ')
						.where('boulders.created_at >= ? AND status = ? AND location_id = ?', 1.week.ago, 1, locationID)
	end



	def rankingTop3Male(locationID)
		return rankingTop3('m', locationID)
	end



	def rankingTop3Female(locationID)
		return rankingTop3('f', locationID)
	end



	def rankingTop3(gender, locationID)
    	rankings = Ranking.find(:all, :joins => :user,
						:conditions => ["rankings.status = 1 
							and users.is_visible = TRUE 
							and rankings.event_id = 0 
							and rankings.gender = '" + gender + "' 
							and location_id = " + locationID.to_s ],
						:order => 'points desc, flashed desc',
						:limit => 3)
		
		counter = 0
		last_rankings = Array.new;
		last_rank = 0;
    	rankings.map{ |ranking| 
			counter = counter + 1

			if rankings[counter] and rankings[counter].points == ranking.points then
				last_rank = counter
				last_rankings.push(ranking)
			else
				if last_rankings.size != 0 then
					last_rankings.map{ |last_ranking| 
						last_ranking.rank = last_rank + 1
					}
					last_rankings = Array.new
				end
			end
			ranking.rank = counter
		}

		return rankings
	end



	def boulderCountLevel(level, locationID)
		if is_admin?
			#return Boulder.where('status = ? AND level_intern = ?', 1, level).count

			return Boulder.joins('INNER JOIN walls ON walls.id = COALESCE(wall_from, wall_to) ')
							.where('status = ? AND location_id = ? AND level_intern = ?', 1, locationID, level).count
		end
		#return Boulder.where('status = ? AND level_public = ?', 1, level).count
		return Boulder.joins('INNER JOIN walls ON walls.id = COALESCE(wall_from, wall_to) ')
						.where('status = ? AND location_id = ? AND level_public = ?', 1, locationID, level).count
	end



	def getEvents(locationID)
		events = get_active_events_by_location(locationID)
		if current_user
			boulders_conquerored = Boulder.joins(:boulder_conquerors).where('status = ? AND user_id = ? AND event_id = ?', 1, current_user.id, 0)
			boulders = Boulder.find_all_by_status(1)
			boulders_todo = boulders.size - boulders_conquerored.size
		end
		return events
	end
	
end
