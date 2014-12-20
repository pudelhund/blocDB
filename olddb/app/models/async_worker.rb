class AsyncWorker 

	def self.updateRanking(logger)
		#### wird nicht mehr asynchron gemacht, sondern so wie früher direkt beim Aufruf des Rankings #####
		#logger.info('------- BEFORE THREAD START -----------------')

		# Prüfen, ob schon ein Thread läuft in dem das Ranking aktualisiert wird. Falls ja beenden wir den, um einen neuen zu starten.
		# Macht man das nicht, hängt sich der Server auf, wenn man schnell nacheinander mehrere Boulder abhakt
		#Thread.list.each { |thread|
		#	if thread.keys.include? :update_ranking
		#		logger.info "-------- A THREAD FOR UPDATING IS ALREADY RUNNING. THIS THREAD WILL BE KILLED -------"
		#		thread.kill
		#	end
		#}

		#Thread.new do
		#	logger.info('----------- UDPATING RANKING ASYNC -----------------')
		#	Thread.current[:update_ranking] = true
		#	ActiveRecord::Base.connection.execute('SELECT sp_ranking();');
		#end
	end
end