extends Control

# When "Try Again" is clicked -> Go straight back to gameplay
func _on_retry_button_pressed():
	GlobalClock.reset_timer()
	GlobalClock.start_timer() # Start the clock immediately for the new run
	
	# IMPORTANT: Change this path to your GAME LEVEL (World, Temple, etc.)
	get_tree().change_scene_to_file("res://scenes/game.tscn") 

# When "Main Menu" is clicked -> Go to the title screen
func _on_main_menu_button_pressed():
	# We reset the timer, but we DO NOT start it (the menu handles that)
	GlobalClock.reset_timer()
	
	# IMPORTANT: Change this path to your MAIN MENU
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
# Using @onready makes it easier to reference the panel
@onready var ui_panel = $UIPanel
@onready var background = $Background

func _ready():
	# --- SETUP THE DROP ANIMATION ---
	
	# 1. Remember the destination.
	# Where you placed the panel in the editor is where we want it to end up.
	var final_position = ui_panel.position
	
	# 2. Move it off-screen to the top.
	# We set its Y position to negative its own height, plus a little extra buffer (50px).
	ui_panel.position.y = -ui_panel.size.y - 50
	
	# 3. Create the Tween
	var tween = create_tween()
	
	# --- CHOOSE YOUR FLAVOR ---
	# Option A: Weighted Drop (Goes past the target slightly and settles back)
	# Good for heavy stone/scroll tablets.
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	# Option B: Bouncy Drop (Bounces like a ball when it hits the center)
	# Uncomment the next line instead if you want it bouncier:
	# tween.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	
	# 4. Animate Position
	# Move from current off-screen position to 'final_position' over 0.8 seconds.
	tween.tween_property(ui_panel, "position", final_position,3)

	# --- OPTIONAL BACKGROUND FADE ---
	# Keep background invisible at start
	background.modulate.a = 0.0
	# Create a separate tween so the background fades in smoothly over 1.5 seconds
	var bg_tween = create_tween()
	bg_tween.tween_property(background, "modulate:a", 1.0, 1.5)
	await get_tree().create_timer(4.0).timeout
	
