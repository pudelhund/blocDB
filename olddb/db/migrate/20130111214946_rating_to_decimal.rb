class RatingToDecimal < ActiveRecord::Migration
	def change
		change_table :boulders do |t|
		  t.change :rating, :decimal, :precision => 2, :scale => 1
		end

		change_table :boulder_ratings do |t|
		  t.change :rating, :decimal, :precision => 2, :scale => 1
		end
	end
end
