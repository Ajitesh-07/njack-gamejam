extends ColorRect

# Visual settings
var start_radius: float = 0.9
var end_radius: float = 0.3

func _ready():
	# Update immediately so there is no "flash" of light when entering a new scene
	update_darkness()

func _process(delta):
	update_darkness()

func update_darkness():
	# 1. Get Time
	var current_time = GlobalClock.time_left
	
	# 2. Handle Game Over
	if GlobalClock.is_game_over:
		material.set_shader_parameter("circle_radius", 0.0)
		return

	# 3. Calculate Darkness
	var time_left_minutes = current_time / 60.0
	var target_radius = start_radius

	if time_left_minutes <= 5.0:
		# Final 5 minutes logic
		var last_leg_progress = 1.0 - (current_time / 300.0)
		target_radius = lerp(0.5, end_radius, last_leg_progress)
	else:
		# First 10 minutes logic
		var first_leg_progress = 1.0 - ((current_time - 300.0) / 600.0)
		target_radius = lerp(start_radius, 0.5, first_leg_progress)

	# 4. Apply
	material.set_shader_parameter("circle_radius", target_radius)
