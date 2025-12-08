# Global.gd

extends Node

# Stores the name/ID of the position where the player should spawn 
# in the next scene. This is the key piece of persistent data.
var current_spawn_id: String = "" 

# Called by the scene-changing object (The Entrance)
func set_spawn_point(id: String):
	current_spawn_id = id
	print("Global: Spawn point set to '", id, "'.")

# Called by the Player after loading a new scene
func get_spawn_point() -> String:
	return current_spawn_id
	
# Optional: Generic reusable scene change function
func change_scene(path: String):
	# Add screen fade logic here later for a professional look
	get_tree().change_scene_to_file(path)
