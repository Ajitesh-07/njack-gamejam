extends Area2D


var speed=300
var direction=Vector2.ZERO
var damage_amount: float = 10
func _physics_process(delta: float) -> void:
	global_position+=speed*direction*delta
	rotation=direction.angle()
	
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemy"):
		return
	# 2. Check if we hit the Player
	if body.is_in_group("Player"):
		if body.has_method("apply_heal"):
			body.apply_heal(-damage_amount) 
			print("Arrow hit Player for ", damage_amount, " damage!")
		queue_free() # Destroy arrow
		
	# 3. Destroy arrow if it hits a wall/floor (anything not the player/enemy)
	else:
		queue_free()
