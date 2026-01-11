extends CharacterBody2D
@onready var Player=get_node("../Player")
@onready var effect=preload("res://scenes/lightning.tscn")
var speed=23
var is_light=true

	
	
	

var player_chase=false
var player=null
var current_dir
var elec_attack=false
var current_att=false

var max_health = 120
var current_health: float
var damage = 34
@onready var health_bar = $HealthBar
var has_attacked = false

@onready var shard_pickup = preload("res://scenes/pickups/LightningShardPickup.tscn")

func _ready() -> void:
	current_health = max_health
	health_bar.max_value = max_health

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

func _physics_process(delta: float) -> void:

	var elec=$AnimatedSprite2D
	
	
	if player_chase and player and !(elec_attack):
		global_position+=(player.global_position-global_position)/speed
		decide_direction()
		if current_dir=="right":
			elec.flip_h=false
			elec.play("walk")
		elif(current_dir=="left"):
			elec.flip_h=true
			elec.play("walk")	
	elif( !(player_chase ) and player and !(elec_attack)):
		if current_dir=="right":
			elec.flip_h=false
			elec.play("idle")
		elif current_dir=="left":
			elec.flip_h=true
			elec.play("idle")		
	attack()			
			
		
	
	
	
	
	

func _on_detection_elec_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_chase=true
		player=body


func _on_detection_elec_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_chase=false
		
		
		
		
func decide_direction():
	if (Player.global_position<global_position):
		current_dir="left"
	else :
		current_dir="right"	
		
			


func _on_hit_box_body_entered(body: Node2D) -> void:
	#print("dected")
	if body.is_in_group("Player") and (!(elec_attack)):
		#print("player")
		elec_attack=true
		player_chase=false
		


func _on_hit_box_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		elec_attack=false
		if(abs(Player.global_position-global_position).length()<=80):
			player_chase=true
		else: 
			player_chase=false	
			
			
func attack():
	
	decide_direction()
	var elec2=$AnimatedSprite2D
	if elec_attack:
		current_att=true
	if elec_attack:
		var frame = $AnimatedSprite2D.frame
		if (frame != 10):
			has_attacked = false
		if current_dir=="right":
			elec2.flip_h=false
			elec2.play("attack")
			
			
			$elec_cool.start()
		if current_dir=="left"	:
			elec2.flip_h=true
			elec2.play("attack")
			
			
			$elec_cool.start()
							
	
		if (frame == 10 and !has_attacked):
			var player = get_tree().get_first_node_in_group("Player")
			player.apply_heal(-damage)
			has_attacked = true


	
func light():
	var light_temp=effect.instantiate()
	light_temp.direction=(Player.global_position-global_position).normalized()
	
	

	light_temp.position=global_position
		
	get_parent().add_child(light_temp)
		
	
			
		

	


	
	


func _on_animated_sprite_2d_frame_changed() -> void:
	
	if $AnimatedSprite2D.frame==7  and (elec_attack==true) :
		light()
		$AudioStreamPlayer2D.play()
		
		
		
		



	
	
	


func _on_elec_cool_timeout() -> void:
	current_att=false
