extends CharacterBody2D


@onready var Player=get_node("../Player")
var speed=30
@export var chase_range: float = 90

var current_dir;
var dir=current_dir;
var player=null
var player_chase=false
var dragon_attack=false
#@onready var Player=get_node("../Player")
var current_attack=false
var damage = 40
var current_health: float
var max_health = 30

@onready var dragon=$AnimatedSprite2D
@onready var water=load("res://scenes/waterball.tscn")
@onready var health_bar = $HealthBar
@onready var shard_pickup = preload("res://scenes/pickups/WaterShardPickup.tscn")

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
	var pickup_instance = shard_pickup.instantiate()
	pickup_instance.global_position = global_position
	get_parent().add_child(pickup_instance)
	queue_free()


func _ready() -> void:
	current_health = max_health
	health_bar.max_value = max_health

func _physics_process(delta: float) -> void:


	

	if player_chase and player and !(dragon_attack):
		
		#print("sat")
		
		
		#print(global_position,player.global_position)
	
		global_position+=(player.global_position-global_position)/speed
		decide_direction()
	
		if current_dir=="left":
			
			dragon.flip_h=false
			dragon.play("fly")
		elif(current_dir=="right"):
			
			dragon.flip_h=true
			dragon.play("fly")	
		
		
		

		
		
		
		
		
	elif(!(player_chase ) and( player==null)):
		
		
		if(current_dir=="left") :
			#print("left")
			dragon.flip_h=false
			dragon.play("idle")
		elif(current_dir=="right") :
		
			dragon.flip_h=true
			dragon.play("idle")	
	attack()		
		
			
			
		
		
		
func decide_direction():
	if Player.global_position<global_position:
		current_dir="left"
	else :
		current_dir="right"	
		
		
		











func _on_detect_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("entered")
		player=body
		player_chase=true
	 


func _on_detect_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player=null
		player_chase =false

	
	


func _on_hit_area_body_entered(body: Node2D) -> void:

	if body.is_in_group("Player"):
		#print("attack")
		player_chase=false
		dragon_attack=true
		
	
	
	
		
		


func _on_hit_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if(Player.global_position-global_position).length()<=chase_range:
			player_chase=true
			dragon_attack=false
		
	
		
		
func water_shoot():
	print("happening ", water)
	var water_t=water.instantiate()
	water_t.position=global_position
	water_t.direction=(Player.global_position-global_position).normalized()
	if "damage_amount" in water_t:
		water_t.damage_amount = damage
	get_parent().add_child(water_t)

	



	
	
	
	
			

	



	
func attack():
	if dragon_attack :
		current_attack=true
	decide_direction()	
	
	if current_dir=="left" and dragon_attack :
	
	
		dragon.flip_h=false
		
		dragon.play("attack")
	
		$dragon_attack_cool.start()
	if current_dir=="right" and  dragon_attack and current_attack:
		dragon.flip_h=true
	
		dragon.play("attack")
		
		$dragon_attack_cool.start()
		
	else:
		pass	


func _on_dragon_cool_timeout() -> void:
	$dragon_attack_cool.stop()
	current_attack=false

	

	


func _on_animated_sprite_2d_frame_changed() -> void:
	if $AnimatedSprite2D.frame==5 and (dragon_attack==true):
	
		
		water_shoot()
		$AudioStreamPlayer2D.play()
