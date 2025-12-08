extends Label

func _process(delta):
	# 1. Get the raw time (in seconds)
	var time_left = GlobalClock.time_left
	
	# 2. Convert to Minutes and Seconds
	# floor() rounds down to the nearest whole number
	var minutes = floor(time_left / 60)
	var seconds = int(time_left) % 60
	
	# 3. Update the text
	# "%02d" means "format as a number with 2 digits" (so you get 05 instead of 5)
	text = "%02d:%02d" % [minutes, seconds]
