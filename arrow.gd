extends Area2D

var speed = 300
var direction = Vector2.ZERO

# Give it a default value so it doesn't crash if the soldier forgets to set it
var damage_amount: int = 10 

func _ready():
	# Automatically connect the signal (so you don't have to do it in the editor)
	connect("body_entered", Callable(self, "_on_body_entered"))
	
	# Safety: Destroy arrow after 5 seconds if it hits nothing
	await get_tree().create_timer(5.0).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	position += speed * direction * delta
	rotation = direction.angle()

func _on_body_entered(body: Node) -> void:
	# 1. Ignore the Soldier who shot it (Prevent self-damage)
	if body.is_in_group("enemy") or body.name.begins_with("Soldier"):
		return
	# Make sure your Soldier node is in the group "Enemy" or simply check class

	# 2. Check if we hit the Player
	if body.is_in_group("Player"):
		if body.has_method("apply_heal"):
			body.apply_heal(-damage_amount) 
			print("Arrow hit Player for ", damage_amount, " damage!")
		queue_free() # Destroy arrow
		
	# 3. Destroy arrow if it hits a wall/floor (anything not the player/enemy)
	else:
		queue_free()
