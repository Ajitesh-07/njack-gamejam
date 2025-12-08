extends Node

# 15 Minutes in seconds
var total_time: float = 15.0 * 60.0 
var time_left: float = 0.0

# State variables
var is_timer_running: bool = false
var is_game_over: bool = false

func _ready():
	# Set the time, but DO NOT start running yet
	time_left = total_time
	is_timer_running = false

func _process(delta):
	# Only count down if the timer is explicitly running and game isn't over
	if is_timer_running and not is_game_over:
		time_left -= delta

		if time_left <= 0:
			time_left = 0
			game_over()

# Call this when "Start Game" is clicked
func start_timer():
	reset_timer()
	is_timer_running = true

# Call this if you pause the game (Optional)
func stop_timer():
	is_timer_running = false

func reset_timer():
	time_left = total_time
	is_game_over = false
	# Note: We usually keep is_timer_running true if resetting during gameplay,
	# but if going back to main menu, set it to false.

func game_over():
	is_game_over = true
	is_timer_running = false
	print("Eclipse Complete.")
