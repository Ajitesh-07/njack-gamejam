extends CharacterBody2D

@export var max_health: int = 50
var current_health: int

@onready var health_bar = $HealthBar
@onready var dragon = $AnimatedSprite2D
@onready var attack_cooldown_timer = $dragon_cool # Renamed for clarity

# Speed needs to be higher for velocity-based movement (e.g., 100-150)
var speed = 100 
@export var chase_range: float = 80
@export var fireball = preload("res://scenes/dragon_fireball.tscn")
@onready var shard_pickup = preload("res://scenes/pickups/FireShardPickup.tscn")

var player = null # The actual player node found via detection
var player_chase = false
var dragon_attack = false
var can_attack = true # Controls attack cooldown

func _ready() -> void:
	current_health = max_health
	health_bar.max_value = max_health
	health_bar.value = current_health

func _physics_process(delta: float) -> void:
	# 1. MOVEMENT LOGIC
	if player_chase and player and not dragon_attack:
		# Calculate direction vector
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		
		# Flip sprite based on movement
		if direction.x < 0:
			dragon.flip_h = false # Face Left
		else:
			dragon.flip_h = true  # Face Right
			
		dragon.play("fly")
		move_and_slide() # Handles collisions correctly!

	# 2. IDLE LOGIC
	elif not player_chase and not dragon_attack:
		velocity = Vector2.ZERO # Stop moving
		dragon.play("idle")
		move_and_slide()

	# 3. ATTACK LOGIC (Separate function call)
	if dragon_attack and player:
		handle_attack()
		
func handle_attack():
	# 1. Flip towards player
	if player.global_position.x < global_position.x:
		dragon.flip_h = false
	else:
		dragon.flip_h = true

	# 2. Attack Logic (Fixed)
	# We trust 'can_attack'. If the timer reset it, we attack again immediately.
	if can_attack:
		dragon.play("attack")
		can_attack = false
		attack_cooldown_timer.start()
		
func fireball_shoot():
	if not player: return
	
	var fireball_t = fireball.instantiate()
	fireball_t.position = global_position
	# Aim at player
	fireball_t.direction = (player.global_position - global_position).normalized()
	get_parent().add_child(fireball_t)

# --- SIGNALS ---

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"): # Make sure group name matches perfectly (Case Sensitive!)
		player = body
		player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = null
		player_chase = false

func _on_hit_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_chase = false
		dragon_attack = true

func _on_hit_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		dragon_attack = false
		player_chase = true

# Reset attack ability when timer ends
func _on_dragon_cool_timeout() -> void:
	can_attack = true
	# Optional: Return to idle if player left range
	if not dragon_attack:
		dragon.play("idle")

# Spawns fireball on specific animation frame
func _on_animated_sprite_2d_frame_changed() -> void:
	# Only shoot if we are actually attacking
	if dragon.animation == "attack" and dragon.frame == 2:
		fireball_shoot()
		if has_node("AudioStreamPlayer2D"):
			$AudioStreamPlayer2D.play()

# Damage Logic
func take_damage(amount: int):
	current_health -= amount
	health_bar.value = current_health
	health_bar.visible = true 

	# FIX: Color(255, 10, 10) is invalid for floats. Use Color(1, 0, 0) for Red.
	modulate = Color(10, 0, 0) # Intense Red Flash
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1), 0.1)

	if current_health <= 0:
		die()

func die():
	dragon.play("hurt")
	var pickup_instance = shard_pickup.instantiate()
	pickup_instance.global_position = global_position
	get_parent().add_child(pickup_instance)
	queue_free()
