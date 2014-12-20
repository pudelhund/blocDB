class RankingsGender < ActiveRecord::Migration
	def change
	  add_column :rankings, :gender, :string
	end
end
