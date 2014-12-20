module UsersHelper
	def compare_class(conquer)
		if !conquer[:user1].nil? && (conquer[:conquer_type1] == 'flash-doubt' || conquer[:conquer_type1] == 'top-doubt')
			return "bad"
		end
	
		if conquer[:user1].nil? && !conquer[:user2].nil?
			return "bad"
		end

		if !conquer[:user1].nil? && conquer[:user2].nil?
			return "good"
		end

		return "ok"
	end


	def get_ape_index(user)
		if user.arm_span.nil? or user.height.nil? 
			return ''
		end
		return user.arm_span - user.height
	end
end
