class FnGetlocationfromboulder < ActiveRecord::Migration
  def up
		execute <<-__EOI
CREATE OR REPLACE FUNCTION getlocationfromboulder(p_boulder_id integer) RETURNS integer AS
$BODY$
DECLARE
	p_location INTEGER = 0;
BEGIN
	p_location := 
		(SELECT w.location_id FROM boulders b
		LEFT JOIN walls w on (b.wall_from = w.id)
		where b.id = p_boulder_id);
	
	IF p_location is null THEN
		p_location := 
			(SELECT w.location_id FROM boulders b
			LEFT JOIN walls w on (b.wall_to = w.id)
			where b.id = p_boulder_id);
	END IF;
	
	RETURN p_location;
END

$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

	   __EOI
  end

  def down
  end
end
