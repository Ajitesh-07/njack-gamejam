# SceneManager.gd
extends CanvasLayer

@onready var dialog = $SceneConfirmDialog

var pending_scene_path: String = ""
var pending_spawn_tag: String = "" # NEW: Stores the destination ID

func _ready():
	dialog.confirmed.connect(_on_confirmed)
	dialog.canceled.connect(_on_cancelled)

# Update arguments to accept the spawn tag
func request_scene_change(scene_path: String, location_name: String, spawn_tag: String):
	pending_scene_path = scene_path
	pending_spawn_tag = spawn_tag # Store it for later
	
	dialog.dialog_text = "Do you want to enter " + location_name + "?"
	get_tree().paused = true
	dialog.popup_centered()

func _on_confirmed():
	get_tree().paused = false
	get_tree().change_scene_to_file(pending_scene_path)
	
	# Note: We do NOT clear pending_spawn_tag yet. 
	# We need it to survive until the new scene loads.

func get_spawn_tag():
	var tag = pending_spawn_tag
	pending_spawn_tag = "" # Reset it after reading it once
	return tag
	
func _on_cancelled():
	get_tree().paused = false
	pending_scene_path = ""
	pending_spawn_tag = ""
