extends Control

# We don't need to export max_health here manually anymore if we read it from the player,
# but keeping it is fine for UI setup.
@export var max_health: float = 100.0 

var current_health: float = 100.0 # Changed default to 100 to match player

func _ready() -> void:
	await get_tree().process_frame
	
	# 1. Find Player
	if !get_tree():
		return
	var players = get_tree().get_nodes_in_group("Player")
	
	if players.size() > 0:
		var player = players[0]
		print("Found Player")
		
		# 2. CONNECT SIGNAL
		player.connect("health_changed", Callable(self, "set_health"))
		
		# 3. SYNC DATA (CRITICAL FIX)
		# We must ask the player "What is your health NOW?" 
		# otherwise the bar might show 10 while player has 100.
		max_health = player.max_health # Sync max health too!
		$HealthRow/HealthBar.max_value = max_health
		set_health(player.health)
		
	else:
		print("UI Error: No Player found in group 'Player'")

func set_health(new_health: float) -> void:
	# Clamp visuals just in case
	new_health = clamp(new_health, 0.0, max_health)
	current_health = new_health
	
	# Animate the bar
	create_tween().tween_property($HealthRow/HealthBar, "value", new_health, 0.22)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
		
	# Update text label
	if $HealthRow.has_node("HealthLabel"):
		$HealthRow.get_node("HealthLabel").text = str(int(new_health)) + " / " + str(int(max_health))
