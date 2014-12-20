class SpRanking02 < ActiveRecord::Migration
  def up
		execute <<-__EOI
CREATE OR REPLACE FUNCTION sp_ranking() RETURNS void AS
$BODY$
DECLARE
  p_row RECORD;
  p_boulder RECORD;
  p_user RECORD;
  p_conquerors INTEGER = 0;
  p_points INTEGER = 0;
  p_conquered INTEGER = 0;
  p_ranking RECORD;
  p_rank INTEGER = 1;
BEGIN
	truncate table rankings;
	truncate table boulder_points_temp;
	
	INSERT INTO boulder_points_temp(boulder_id, points, status, event_id, location_id)
	(select boulder_id, b.points / count(boulder_id), b.status, bc.event_id, getLocationFromBoulder(boulder_id) from boulder_conquerors bc 
	left join boulders b on (b.id = boulder_id)
	left join users u on (bc.user_id = u.id)
	where bc.event_id = 0 and u.is_visible = true and type in ('flash', 'top')
	group by boulder_id, b.points, b.status, bc.event_id);
	
	for p_row in
      select distinct(location_id) from boulder_points_temp where location_id is not null
    loop   
	
		INSERT INTO rankings (user_id, points, conquer_count, status, created_at, updated_at, event_id, flashed, gender, location_id)
		select user_id, 
		sum(case when bc.type = 'flash' then
			(points * 1.1)
			when bc.type = 'top' then
			points
			end
		) as points, 
		count(case when bc.type in ('flash','top') then
			1
			end
		) as conquer_count, 0, now(), now(), bc.event_id, 
		count(case when bc.type = 'flash' then
			1
			end
		) as flashed, 'a', p_row.location_id
		from boulder_points_temp bpt 
		left join boulder_conquerors bc on (bpt.boulder_id = bc.boulder_id) 
		left join users u on (bc.user_id = u.id)
		where bpt.status = 0 and bc.event_id = 0 and u.is_visible = true
		group by user_id, bc.event_id order by points desc;
		
		INSERT INTO rankings (user_id, points, conquer_count, status, created_at, updated_at, event_id, flashed, gender, location_id)
		select user_id, 
		sum(case when bc.type = 'flash' then
			(points * 1.1)
			when bc.type = 'top' then
			points
			end
		) as points, 
		count(case when bc.type in ('flash','top') then
			1
			end
		) as conquer_count, 1, now(), now(), bc.event_id,
		count(case when bc.type = 'flash' then
			1
			end
		) as flashed, 'a', p_row.location_id
		from boulder_points_temp bpt 
		left join boulder_conquerors bc on (bpt.boulder_id = bc.boulder_id) 
		left join users u on (bc.user_id = u.id)
		where bpt.status = 1 and bc.event_id = 0 and u.is_visible = true
		group by user_id, bc.event_id order by points desc;

	end loop;
	
	/* MAENNER */
	truncate table boulder_points_temp;
	
	INSERT INTO boulder_points_temp(boulder_id, points, status, event_id, location_id)
	(select boulder_id, b.points / count(boulder_id), b.status, bc.event_id, getLocationFromBoulder(boulder_id) from boulder_conquerors bc 
	left join boulders b on (b.id = boulder_id)
	left join users u on (bc.user_id = u.id)
	where bc.event_id = 0 and u.is_visible = true and type in ('flash', 'top')
	and u.gender = 'm'
	group by boulder_id, b.points, b.status, bc.event_id);
	
	for p_row in
      select distinct(location_id) from boulder_points_temp where location_id is not null
    loop   
	
		INSERT INTO rankings (user_id, points, conquer_count, status, created_at, updated_at, event_id, flashed, gender, location_id)
		select user_id, 
		sum(case when bc.type = 'flash' then
			(points * 1.1)
			when bc.type = 'top' then
			points
			end
		) as points, 
		count(case when bc.type in ('flash','top') then
			1
			end
		) as conquer_count, 0, now(), now(), bc.event_id, 
		count(case when bc.type = 'flash' then
			1
			end
		) as flashed, 'm', p_row.location_id
		from boulder_points_temp bpt 
		left join boulder_conquerors bc on (bpt.boulder_id = bc.boulder_id) 
		left join users u on (bc.user_id = u.id)
		where bpt.status = 0 and bc.event_id = 0 and u.is_visible = true
		and u.gender = 'm'
		group by user_id, bc.event_id order by points desc;
		
		INSERT INTO rankings (user_id, points, conquer_count, status, created_at, updated_at, event_id, flashed, gender, location_id)
		select user_id, 
		sum(case when bc.type = 'flash' then
			(points * 1.1)
			when bc.type = 'top' then
			points
			end
		) as points, 
		count(case when bc.type in ('flash','top') then
			1
			end
		) as conquer_count, 1, now(), now(), bc.event_id,
		count(case when bc.type = 'flash' then
			1
			end
		) as flashed, 'm', p_row.location_id
		from boulder_points_temp bpt 
		left join boulder_conquerors bc on (bpt.boulder_id = bc.boulder_id) 
		left join users u on (bc.user_id = u.id)
		where bpt.status = 1 and bc.event_id = 0 and u.is_visible = true
		and u.gender = 'm'
		group by user_id, bc.event_id order by points desc;
	
	end loop;
	
	/* FRAUEN */
	truncate table boulder_points_temp;
	
	INSERT INTO boulder_points_temp(boulder_id, points, status, event_id, location_id)
	(select boulder_id, b.points / count(boulder_id), b.status, bc.event_id, getLocationFromBoulder(boulder_id) from boulder_conquerors bc 
	left join boulders b on (b.id = boulder_id)
	left join users u on (bc.user_id = u.id)
	where bc.event_id = 0 and u.is_visible = true and type in ('flash', 'top')
	and u.gender = 'f'
	group by boulder_id, b.points, b.status, bc.event_id);
	
	for p_row in
      select distinct(location_id) from boulder_points_temp where location_id is not null
    loop   
	
		INSERT INTO rankings (user_id, points, conquer_count, status, created_at, updated_at, event_id, flashed, gender, location_id)
		select user_id, 
		sum(case when bc.type = 'flash' then
			(points * 1.1)
			when bc.type = 'top' then
			points
			end
		) as points, 
		count(case when bc.type in ('flash','top') then
			1
			end
		) as conquer_count, 0, now(), now(), bc.event_id, 
		count(case when bc.type = 'flash' then
			1
			end
		) as flashed, 'f', p_row.location_id
		from boulder_points_temp bpt 
		left join boulder_conquerors bc on (bpt.boulder_id = bc.boulder_id) 
		left join users u on (bc.user_id = u.id)
		where bpt.status = 0 and bc.event_id = 0 and u.is_visible = true
		and u.gender = 'f'
		group by user_id, bc.event_id order by points desc;
		
		INSERT INTO rankings (user_id, points, conquer_count, status, created_at, updated_at, event_id, flashed, gender, location_id)
		select user_id, 
		sum(case when bc.type = 'flash' then
			(points * 1.1)
			when bc.type = 'top' then
			points
			end
		) as points, 
		count(case when bc.type in ('flash','top') then
			1
			end
		) as conquer_count, 1, now(), now(), bc.event_id,
		count(case when bc.type = 'flash' then
			1
			end
		) as flashed, 'f', p_row.location_id
		from boulder_points_temp bpt 
		left join boulder_conquerors bc on (bpt.boulder_id = bc.boulder_id) 
		left join users u on (bc.user_id = u.id)
		where bpt.status = 1 and bc.event_id = 0 and u.is_visible = true
		and u.gender = 'f'
		group by user_id, bc.event_id order by points desc;
		
	end loop;
	
	/* EVENT RANKING */
	/* ALLE */
	truncate table boulder_points_temp;
	
	INSERT INTO boulder_points_temp(boulder_id, points, status, event_id)
	(select boulder_id, b.points / count(boulder_id), b.status, bc.event_id from boulder_conquerors bc 
	left join boulders b on (b.id = boulder_id)
	left join users u on (bc.user_id = u.id)
	left join event_participants ep on (bc.event_id = ep.event_id)
	where bc.event_id != 0 and u.is_visible = true and type in ('flash', 'top')
	and bc.user_id = ep.user_id
	group by boulder_id, b.points, b.status, bc.event_id);
	
	INSERT INTO rankings (user_id, points, conquer_count, status, created_at, updated_at, event_id, flashed, gender)
	select bc.user_id, 
	sum(case when bc.type = 'flash' then
		(points * 1.1)
	    when bc.type = 'top' then
		points
	    end
	) as points, 
	count(case when bc.type in ('flash','top') then
		1
	    end
	) as conquer_count, 0, now(), now(), bc.event_id,
	count(case when bc.type = 'flash' then
		1
	    end
	) as flashed, 'a'
	from boulder_points_temp bpt 
	left join boulder_conquerors bc on (bpt.boulder_id = bc.boulder_id and bpt.event_id = bc.event_id) 
	left join event_participants ep on (bc.event_id = ep.event_id)
	where bpt.status = 0 and bc.event_id != 0
	and bc.user_id = ep.user_id
	group by bc.user_id, bc.event_id order by points desc;
	
	INSERT INTO rankings (user_id, points, conquer_count, status, created_at, updated_at, event_id, flashed, gender)
	select bc.user_id, 
	sum(case when bc.type = 'flash' then
		(points * 1.1)
	    when bc.type = 'top' then
		points
	    end
	) as points, 
	count(case when bc.type in ('flash','top') then
		1
	    end
	) as conquer_count, 1, now(), now(), bc.event_id,
	count(case when bc.type = 'flash' then
		1
	    end
	) as flashed, 'a'
	from boulder_points_temp bpt 
	left join boulder_conquerors bc on (bpt.boulder_id = bc.boulder_id and bpt.event_id = bc.event_id) 
	left join event_participants ep on (bc.event_id = ep.event_id)
	where bpt.status = 1 and bc.event_id != 0
	and bc.user_id = ep.user_id
	group by bc.user_id, bc.event_id order by points desc;

	/* EVENTS MAENNER */
	truncate table boulder_points_temp;
	
	INSERT INTO boulder_points_temp(boulder_id, points, status, event_id)
	(select boulder_id, b.points / count(boulder_id), b.status, bc.event_id from boulder_conquerors bc 
	left join boulders b on (b.id = boulder_id)
	left join users u on (bc.user_id = u.id)
	left join event_participants ep on (bc.event_id = ep.event_id)
	where bc.event_id != 0 and u.is_visible = true and type in ('flash', 'top')
	and u.gender = 'm'
	and bc.user_id = ep.user_id
	group by boulder_id, b.points, b.status, bc.event_id);
	
	INSERT INTO rankings (user_id, points, conquer_count, status, created_at, updated_at, event_id, flashed, gender)
	select bc.user_id, 
	sum(case when bc.type = 'flash' then
		(points * 1.1)
	    when bc.type = 'top' then
		points
	    end
	) as points, 
	count(case when bc.type in ('flash','top') then
		1
	    end
	) as conquer_count, 0, now(), now(), bc.event_id,
	count(case when bc.type = 'flash' then
		1
	    end
	) as flashed, 'm'
	from boulder_points_temp bpt 
	left join boulder_conquerors bc on (bpt.boulder_id = bc.boulder_id and bpt.event_id = bc.event_id) 
	left join users u on (bc.user_id = u.id)
	left join event_participants ep on (bc.event_id = ep.event_id)
	where bpt.status = 0 and bc.event_id != 0
	and u.gender = 'm'
	and bc.user_id = ep.user_id
	group by bc.user_id, bc.event_id order by points desc;
	
	INSERT INTO rankings (user_id, points, conquer_count, status, created_at, updated_at, event_id, flashed, gender)
	select bc.user_id, 
	sum(case when bc.type = 'flash' then
		(points * 1.1)
	    when bc.type = 'top' then
		points
	    end
	) as points, 
	count(case when bc.type in ('flash','top') then
		1
	    end
	) as conquer_count, 1, now(), now(), bc.event_id,
	count(case when bc.type = 'flash' then
		1
	    end
	) as flashed, 'm'
	from boulder_points_temp bpt 
	left join boulder_conquerors bc on (bpt.boulder_id = bc.boulder_id and bpt.event_id = bc.event_id) 
	left join users u on (bc.user_id = u.id)
	left join event_participants ep on (bc.event_id = ep.event_id)
	where bpt.status = 1 and bc.event_id != 0
	and u.gender = 'm'
	and bc.user_id = ep.user_id
	group by bc.user_id, bc.event_id order by points desc;

	/* EVENTS FRAUEN */
	truncate table boulder_points_temp;
	
	INSERT INTO boulder_points_temp(boulder_id, points, status, event_id)
	(select boulder_id, b.points / count(boulder_id), b.status, bc.event_id from boulder_conquerors bc 
	left join boulders b on (b.id = boulder_id)
	left join users u on (bc.user_id = u.id)
	left join event_participants ep on (bc.event_id = ep.event_id)
	where bc.event_id != 0 and u.is_visible = true and type in ('flash', 'top')
	and u.gender = 'f'
	and bc.user_id = ep.user_id
	group by boulder_id, b.points, b.status, bc.event_id);
	
	INSERT INTO rankings (user_id, points, conquer_count, status, created_at, updated_at, event_id, flashed, gender)
	select bc.user_id, 
	sum(case when bc.type = 'flash' then
		(points * 1.1)
	    when bc.type = 'top' then
		points
	    end
	) as points, 
	count(case when bc.type in ('flash','top') then
		1
	    end
	) as conquer_count, 0, now(), now(), bc.event_id,
	count(case when bc.type = 'flash' then
		1
	    end
	) as flashed, 'f'
	from boulder_points_temp bpt 
	left join boulder_conquerors bc on (bpt.boulder_id = bc.boulder_id and bpt.event_id = bc.event_id) 
	left join users u on (bc.user_id = u.id)
	left join event_participants ep on (bc.event_id = ep.event_id)
	where bpt.status = 0 and bc.event_id != 0
	and u.gender = 'f'
	and bc.user_id = ep.user_id
	group by bc.user_id, bc.event_id order by points desc;
	
	INSERT INTO rankings (user_id, points, conquer_count, status, created_at, updated_at, event_id, flashed, gender)
	select bc.user_id, 
	sum(case when bc.type = 'flash' then
		(points * 1.1)
	    when bc.type = 'top' then
		points
	    end
	) as points, 
	count(case when bc.type in ('flash','top') then
		1
	    end
	) as conquer_count, 1, now(), now(), bc.event_id,
	count(case when bc.type = 'flash' then
		1
	    end
	) as flashed, 'f'
	from boulder_points_temp bpt 
	left join boulder_conquerors bc on (bpt.boulder_id = bc.boulder_id and bpt.event_id = bc.event_id) 
	left join users u on (bc.user_id = u.id)
	left join event_participants ep on (bc.event_id = ep.event_id)
	where bpt.status = 1 and bc.event_id != 0
	and u.gender = 'f'
	and bc.user_id = ep.user_id
	group by bc.user_id, bc.event_id order by points desc;
	
	UPDATE rankings SET points = 0 WHERE points IS NULL;
END

$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

	   __EOI
  end

  def down
  end
end
