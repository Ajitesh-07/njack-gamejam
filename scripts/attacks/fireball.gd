extends Area2D

# We'll set these from the player when we spawn it
var speed: float = 100
var direction: Vector2 = Vector2.ZERO

# We can also add damage here
var damage: int = 10

func _physics_process(delta):
	global_position += direction * speed * delta

func _on_body_entered(body, ignore_group = "Player"):
	if body.is_in_group(ignore_group):
		return
	if body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
	# We hit something (an enemy or a wall), so destroy ourselves.
	queue_free()

func _on_lifetime_timer_timeout():
	queue_free()
