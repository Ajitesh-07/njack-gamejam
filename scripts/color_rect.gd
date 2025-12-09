extends ColorRect

# Visual settings
var start_radius: float = 0.8
# You updated this to 0.25 recently
var end_radius: float = 0.25  

func _ready():
	# Update immediately so there is no "flash" of light
	update_darkness()

func _process(delta):
	update_darkness()

func update_darkness():
	# Safety check
	if not GlobalClock:
		return
		
	var current_time = GlobalClock.time_left
	
	# Handle Game Over (Total Blackness)
	if GlobalClock.is_game_over:
		material.set_shader_parameter("circle_radius", 0.0)
		return

	# --- 1. Calculate Radius (Size) ---
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

	# --- 2. PULSE EFFECT (New Red Flash Logic) ---
	# Only happens in the final 60 seconds
	if current_time <= 60.0:
		var pulse_speed = 8.0 
		# This creates a value that goes up and down between 0 and 1
		var pulse_amount = (sin(current_time * pulse_speed) + 1.0) * 0.5 
		
		# Mix Black with Dark Red
		var danger_color = Color(0.0, 0.0, 0.0).lerp(Color(0.5, 0.0, 0.0), pulse_amount * 0.6)
		material.set_shader_parameter("vignette_color", danger_color)
	else:
		# If more than 60s left, keep it pure black
		material.set_shader_parameter("vignette_color", Color(0.0, 0.0, 0.0))

	# --- 3. Apply the Size ---
	material.set_shader_parameter("circle_radius", target_radius)
