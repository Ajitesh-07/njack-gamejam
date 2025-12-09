# ScenePortal.gd
extends Area2D

@export_file("*.tscn") var target_scene_path: String
@export var location_name: String = "Unknown Location"

# NEW: The ID of the door we want to go TO
@export var target_spawn_tag: String = "" 

# NEW: The ID of THIS door (so others can find it)
@export var my_spawn_tag: String = ""

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":
		if target_scene_path == "": return
		
		# Pass the target_spawn_tag to the manager
		SceneManager.request_scene_change(target_scene_path, location_name, target_spawn_tag)
