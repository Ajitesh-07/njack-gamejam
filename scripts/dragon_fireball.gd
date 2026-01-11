extends Area2D

# How much damage the fireball deals
var damage_amount: int = 25

var speed = 300
var direction=Vector2.ZERO

func _physics_process(delta):
	position += direction*speed*delta
	rotation=direction.angle()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		return
	print("Body: ", body)
	# This prevents the game from crashing if the fireball hits a wall or floor
	if body.has_method("apply_heal"):
		# 2. Call the method with a NEGATIVE value to deal damage
		body.apply_heal(-damage_amount)
		
		# Optional: Print to console for debugging
		print("Player hit! Dealt ", damage_amount, " damage.")
		
		# 3. Destroy the fireball immediately so it doesn't hit twice
		explode()
	
	# If it hits a wall/floor (something that isn't the player), just destroy it
	else:
		explode()

func explode() -> void:
	# You can add particle effects or sound logic here later
	queue_free()
