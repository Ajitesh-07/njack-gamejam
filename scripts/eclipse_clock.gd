extends Control

@onready var moon = $Moon

# CONFIGURATION
# 1. The X position where the moon starts (Full Sun visible)
# Adjust this number to match where you placed it in the editor!
var start_x_position = -25

# 2. The X position where the moon ends (Sun fully covered)
# Usually 0.0 if aligned with the parent container
var end_x_position = 0

func _process(delta):
	# 1. Get the progress (0.0 = Start, 1.0 = End)
	# We access the total time from your GlobalClock script
	var total_time = GlobalClock.total_time 
	var current_time = GlobalClock.time_left
	
	# Calculate how much time has passed as a percentage (0 to 1)
	var progress = 1.0 - (current_time / total_time)
	
	# 2. Move the Moon
	# 'lerp' calculates the position between Start and End based on progress
	moon.position.x = lerp(start_x_position, end_x_position, progress)
