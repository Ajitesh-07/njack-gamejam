extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return
	
	var inventory = GlobalInventory
	
	var requirements = {
		"FireShard": 2,
		"WaterShard": 2,
		"EarthShard": 1,
		"LightningShard": 1
	}
	
	var current_counts = {
		"FireShard": 0,
		"WaterShard": 0,
		"EarthShard": 0,
		"LightningShard": 0
	}
	
	for slot in inventory.slots:
		if slot and slot.item:
			var item_name = slot.item.display_name
			
			if item_name in current_counts:
				current_counts[item_name] += slot.count


	var has_all_items = true
	
	for key in requirements:
		if current_counts[key] < requirements[key]:
			has_all_items = false
			print("Missing " + key + ": Have " + str(current_counts[key]) + "/" + str(requirements[key]))
	
	if has_all_items:
		print("SUCCESS: All shards collected!")
		GlobalInventory.clear_inventory()
		get_tree().change_scene_to_file("res://scenes/game_win.tscn")
	else:
		print("FAILURE: You do not have the required shards.")
