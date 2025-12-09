extends CharacterBody2D

@export var speed = 170.0

@onready var animated_sprite = $AnimatedSprite2D
signal health_changed(new_health: float)
var health: float = 10;

@export var fireball_scene = preload("res://scenes/attacks/fireball.tscn")

func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if direction != Vector2.ZERO:
		velocity = direction * speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)

	move_and_slide()
	update_animation()

func update_animation():
	var current_anim = animated_sprite.animation

	if velocity.length() > 0:
		
		if velocity.y < 0:
			animated_sprite.play("back_walk")
		elif velocity.y > 0:
			animated_sprite.play("front_walk")
		elif velocity.x != 0:
			animated_sprite.play("side_walk")
			animated_sprite.flip_h = velocity.x < 0
	else:
		
		if current_anim == "back_walk":
			animated_sprite.play("back_idle")
		elif current_anim == "front_walk":
			animated_sprite.play("front_idle")
		elif current_anim == "side_walk":
			animated_sprite.play("side_idle")

func apply_heal(amount):
	print("Applying Heal")
	health = clamp(health + amount, 0, 100)
	emit_signal("health_changed", health)

func cast_fireball():
	print("Casting Fireball")
	var fireball = fireball_scene.instantiate()
	var dir = (get_global_mouse_position() - global_position).normalized()
	fireball.direction = dir
	fireball.global_position = global_position
	
	fireball.rotation = dir.angle()
	get_tree().root.add_child(fireball)
	
	# 1. Create a new fireball instance
	#var fireball = fireball_scene.instantiate()
	#
	## 2. Figure out the direction: from player to mouse 
	#var direction_to_mouse = (get_global_mouse_position() - global_position).normalized()
	#
	## 3. Set the fireball's variables
	#fireball.direction = direction_to_mouse
	#fireball.global_position = global_position # It spawns on top of the player
	#
	## 4. Make the fireball look where it's going
	#fireball.rotation = direction_to_mouse.angle()
	#
	## 5. Add the fireball to the main scene (NOT the player)
	#get_tree().root.add_child(fireball)
func _ready():
	# Wait for world to load
	await get_tree().process_frame
	
	# 1. GET THE TAG
	var incoming_tag = SceneManager.get_spawn_tag()
	print("----- SPAWN DEBUG -----")
	print("1. Scene Manager sent tag: [", incoming_tag, "]")
	
	if incoming_tag == "":
		print("FAIL: Tag is empty. You likely didn't set 'Target Spawn Tag' on the door you just walked through.")
		return
	
	# 2. FIND THE DOORS
	var portals = get_tree().get_nodes_in_group("Portals")
	print("2. Found ", portals.size(), " portals in this scene.")
	
	# 3. MATCH THE TAG
	for portal in portals:
		print("   - Checking portal with 'My Spawn Tag': [", portal.my_spawn_tag, "]")
		if portal.my_spawn_tag == incoming_tag:
			print("SUCCESS: Match found! Teleporting player.")
			global_position = portal.get_node("SpawnPosition").global_position
			return
			
	print("FAIL: No portal matched the tag. Check for typos!")
	print("-----------------------")
