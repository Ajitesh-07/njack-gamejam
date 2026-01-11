#extends CharacterBody2D
#@onready var Player=get_node("../Player")
#@onready var arrow=preload("res://arrow.tscn")
#var speed=27
#
#
#
#
#
	#
	#
	#
#
#var player_chase=false
#var player=null
#var current_dir
#var attack=false
#var current_att=false
#func _physics_process(delta: float) -> void:
#
	#var elec=$AnimatedSprite2D
	#
	#
	#if player_chase and player and !(attack):
		#global_position+=(player.global_position-global_position)/speed
		#decide_direction()
		#if current_dir=="right":
			#elec.flip_h=false
			#elec.play("walk")
		#elif(current_dir=="left"):
			#elec.flip_h=true
			#elec.play("walk")	
	#elif( !(player_chase ) and player and !(attack)):
		#if current_dir=="right":
			#elec.flip_h=false
			#elec.play("idle")
		#elif current_dir=="left":
			#elec.flip_h=true
			#elec.play("idle")		
	#attack1()			
			#
		#
	#
	#
	#
	#
	#
#
#func _on_detection_body_entered(body: Node2D) -> void:
	#if body.is_in_group("Player"):
		#player_chase=true
		#player=body
#
#
#func _on_detection_body_exited(body: Node2D) -> void:
	#if body.is_in_group("Player"):
		#player_chase=false
		#
		#
		#
		#
#func decide_direction():
	#if (Player.global_position<global_position):
		#current_dir="left"
	#else :
		#current_dir="right"	
		#
			#
#
#
#func _on_hit_area_body_entered(body: Node2D) -> void:
	#
	#if body.is_in_group("Player") and(!(attack)):
		#print("player")
		#attack=true
		#player_chase=false
		#
#
#
#func _on_hit_area_body_exited(body: Node2D) -> void:
	#if body.is_in_group("Player"):
		#attack=false
		#if(abs(Player.global_position-global_position).length()<=80):
			#player_chase=true
		#else: 
			#player_chase=false	
			#
			#
#func attack1():
	#
	#decide_direction()
	#var elec2=$AnimatedSprite2D
	#if attack:
		#current_att=true
	#if attack:
		#print($AnimatedSprite2D.frame)
		#print("attack")
		#if current_dir=="right":
			#elec2.flip_h=false
			#elec2.play("attack")
			#
			#
			#$cool.start()
		#if current_dir=="left"	:
			#elec2.flip_h=true
			#elec2.play("attack")
			#
			#
			#$cool.start()
							#
		#
#
#
#
	#
#func shoot():
	#var arrow_temp=arrow.instantiate()
	#arrow_temp.direction=(Player.global_position-global_position).normalized()
	#
	#
#
	#arrow_temp.position=global_position
		#
	#get_parent().add_child(arrow_temp)
		#
	#
			#
		#
#
	#
#
#
	#
	#
#
#
#func _on_animated_sprite_2d_frame_changed() -> void:
	#
	#if $AnimatedSprite2D.frame==8 and (attack==true) :
		#shoot()
		#$AudioStreamPlayer2D.play()
		#
		#
		#
		#
#
#
#
	#
	#
	#
#
#W
#func _on_cool_timeout() -> void:
	#current_att=false


extends CharacterBody2D

# --- STATS ---
@export var max_health: float = 60.0
@export var damage: int = 16
@export var speed: float = 80.0
@export var attack_range: float = 40
var arrow_scene = preload("res://arrow.tscn")
# --- NODES ---
@onready var animated_sprite = $AnimatedSprite2D
@onready var cooldown_timer = $cool
# Assuming your detection area is named "DetectionArea". 
# IF IT IS NOT, dragging the node from the scene tree into the code holding CTRL to fix the path.
@onready var detection_area = $DetectionArea 

# --- VARIABLES ---
var player: Node2D = null
var is_attacking: bool = false
var can_attack: bool = true
var is_hurt: bool = false
var is_dying: bool = false
var current_health: float
@onready var health_bar = $HealthBar
@onready var shard_pickup = preload("res://scenes/pickups/EarthShardPickup.tscn")

func _ready():
	print("--- SOLDIER READY ---")
	print("1. Script is attached and running.")
	current_health = max_health
	health_bar.max_value = max_health

	
	# Check for nodes
	if not animated_sprite: print("ERROR: AnimatedSprite2D missing!")
	if not cooldown_timer: print("ERROR: Timer 'cool' missing!")
	
	# DEBUG: Check if signals are actually connected via code
	# (Change "DetectionArea" to whatever your Area2D node is named in the Scene Tree)
	# This checks if you forgot to connect the signal in the editor.
	if detection_area:
		if not detection_area.is_connected("body_entered", Callable(self, "_on_detection_body_entered")):
			print("CRITICAL ERROR: 'body_entered' signal is NOT connected! The soldier is blind.")
		else:
			print("2. Signal Connection verified.")
	else:
		print("WARNING: I could not find 'DetectionArea' node to check signals.")

func _physics_process(delta: float) -> void:
	# Debug prints to catch 'stuck' states
	if is_dying:
		print_once("Soldier is marked DEAD. Logic stopped.")
		return
	if is_hurt:
		print_once("Soldier is marked HURT. Logic stopped.")
		return

	if not player:
		# If this prints, your collision layers are wrong or signal is broken
		print_once("Idle... Waiting for player to enter area...")
		if not is_attacking: animated_sprite.play("idle")
		return

	# If we get here, Player IS detected
	var dist = global_position.distance_to(player.global_position)

	# Movement Logic
	var dir_to_player = (player.global_position - global_position).normalized()
	update_facing_direction(dir_to_player.x)

	if is_attacking:
		velocity = Vector2.ZERO
	elif dist <= attack_range:
		velocity = Vector2.ZERO
		if can_attack:
			start_attack()
		elif not is_attacking:
			animated_sprite.play("idle")
	else:
		velocity = dir_to_player * speed
		animated_sprite.play("walk")
	
	move_and_slide()

# Helper to stop spamming the console 60 times a second
var last_print = ""
func print_once(text):
	if text != last_print:
		print(text)
		last_print = text

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


# --- SIGNALS ---
func _on_detection_body_entered(body: Node2D) -> void:
	print("!!! BODY ENTERED DETECTION ZONE: ", body.name, " !!!")
	if body.is_in_group("Player"):
		print("It is the Player! Chase started.")
		player = body
	else:
		print("Ignored object: ", body.name, " (Not in group 'Player')")

func _on_detection_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Player left zone.")
		player = null
		velocity = Vector2.ZERO

# --- BOILERPLATE (Keep this same as before) ---
func update_facing_direction(dir_x):
	if abs(dir_x) > 0.1: animated_sprite.flip_h = dir_x < 0
func start_attack():
	print("Starting Attack!")
	is_attacking = true
	can_attack = false
	animated_sprite.play("attack")
func _on_animated_sprite_2d_frame_changed():
	if animated_sprite.animation == "attack" and animated_sprite.frame == 8:
		shoot_arrow()
func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "attack":
		is_attacking = false
		cooldown_timer.start()
		animated_sprite.play("idle")
	elif animated_sprite.animation == "hurt":
		is_hurt = false
		animated_sprite.play("idle")
	elif animated_sprite.animation == "die":
		queue_free()
func _on_cool_timeout(): can_attack = true
func apply_heal(amount):
	current_health += amount
	if current_health <= 0: die()
	elif amount < 0: 
		is_hurt = true
		animated_sprite.play("hurt")
func die():
	is_dying = true
	animated_sprite.play("die")
	var pickup_instance = shard_pickup.instantiate()
	pickup_instance.global_position = global_position
	get_parent().add_child(pickup_instance)

	queue_free()
	
func shoot_arrow():
	if not player: return
	var arrow_instance = arrow_scene.instantiate()
	var dir = (player.global_position - global_position).normalized()
	arrow_instance.direction = dir
	arrow_instance.rotation = dir.angle()
	arrow_instance.global_position = global_position
	if "damage_amount" in arrow_instance:
		arrow_instance.damage_amount = damage
	get_parent().add_child(arrow_instance)
