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
	# If the timer isn't running or the game is already over, do nothing
	if not is_timer_running or is_game_over:
		return

	# --- DEV CHEATS START ---
	var speed_multiplier = 1.0
	
	# Cheat 1: FAST FORWARD
	# If you hold "T" (for Time), time passes 60x faster.
	# (1 real second = 1 minute in game)
	if Input.is_physical_key_pressed(KEY_T):
		speed_multiplier = 60.0
		
	# Cheat 2: INSTANT DOOM
	# If you press "P" (for Panic), time jumps to the final 10 seconds.
	if Input.is_physical_key_pressed(KEY_P):
		time_left = 10.0
	# --- DEV CHEATS END ---

	# Calculate time
	time_left -= delta * speed_multiplier

	# Check for Game Over
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
	if is_game_over:
		return
		
	is_game_over = true
	is_timer_running = false
	print("Eclipse Complete. Switching to Game Over screen.")
	
	# CHANGE SCENE
	# Make sure this path exactly matches where you saved GameOver.tscn
	get_tree().change_scene_to_file("res://scenes/GameOver.tscn")
