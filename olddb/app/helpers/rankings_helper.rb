module RankingsHelper
	def getPoints(actualPoints, lastPoints)
		if(lastPoints != 0)
			actualPoints.to_s + " (" + (lastPoints - actualPoints).to_s + ")"
		else
			actualPoints.to_s + " (0)"
		end
	end

	def getGroup(gender)
		gender == "m" ? "Herren" : "Damen"
	end
end
