extends Control

@onready var controls_popup = $ControlsPopup
func _on_controls_button_pressed():
	if controls_popup:
		controls_popup.open()# Calls the function inside the popup script
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if controls_popup:
		controls_popup.visible = false
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/StoryIntro.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
	
