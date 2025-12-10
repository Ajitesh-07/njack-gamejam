extends ColorRect

# --- CONFIGURATION ---
var start_radius: float = 0.8
var plateau_radius: float = 0.5 # The constant size it holds from 5 min to 1 min
var end_radius: float = 0.0 # Final size at 0:00 (0.0 = Total Blackness)

# Time triggers
var time_max = 900.0 # 15 min
var time_plateau = 300.0 # 5 min (Start holding constant)
var time_panic = 60.0 # 1 min (Start rapid dropping)

func _ready():
	update_darkness()

func _process(delta):
	update_darkness()

func update_darkness():
	# Safety check
	if not GlobalClock:
		return
		
	var current_time = GlobalClock.time_left
	
	# Handle Game Over (Instant Blackout)
	if GlobalClock.is_game_over:
		material.set_shader_parameter("circle_radius", 0.0)
		return

	# --- 1. CALCULATE RADIUS (New 3-Phase Logic) ---
	var target_radius = start_radius

	# PHASE 1: Normal Decay (15 min -> 5 min)
	if current_time > time_plateau:
		# Calculate progress: 0.0 (at start) -> 1.0 (at 5 min mark)
		var range_len = time_max - time_plateau
		var progress = 1.0 - ((current_time - time_plateau) / range_len)
		target_radius = lerp(start_radius, plateau_radius, progress)
		
	# PHASE 2: The Plateau (5 min -> 1 min)
	elif current_time > time_panic:
		# Stay exactly constant!
		target_radius = plateau_radius
		
	# PHASE 3: Rapid Drop (Last 60 seconds)
	else:
		# Drop fast from Plateau (0.4) to Zero (0.0)
		# Progress: 0.0 (at 1 min) -> 1.0 (at 0 min)
		var progress = 1.0 - (current_time / time_panic)
		target_radius = lerp(plateau_radius, end_radius, progress)

	# --- 2. PULSE EFFECT (Your existing Red Flash) ---
	# Only happens in the final 60 seconds (Phase 3)
	if current_time <= time_panic:
		var pulse_speed = 8.0 
		var pulse_amount = (sin(current_time * pulse_speed) + 1.0) * 0.5 
		
		# Mix Black with Dark Red
		var danger_color = Color(0.0, 0.0, 0.0).lerp(Color(0.5, 0.0, 0.0), pulse_amount * 0.6)
		material.set_shader_parameter("vignette_color", danger_color)
	else:
		# Keep it pure black otherwise
		material.set_shader_parameter("vignette_color", Color(0.0, 0.0, 0.0))

	# --- 3. APPLY TO SHADER ---
	material.set_shader_parameter("circle_radius", target_radius)
