extends CharacterBody2D
@onready var Player=get_node("../Player")
@onready var arrow=preload("res://arrow.tscn")
var speed=27





	
	
	

var player_chase=false
var player=null
var current_dir
var attack=false
var current_att=false
func _physics_process(delta: float) -> void:

	var elec=$AnimatedSprite2D
	
	
	if player_chase and player and !(attack):
		global_position+=(player.global_position-global_position)/speed
		decide_direction()
		if current_dir=="right":
			elec.flip_h=false
			elec.play("walk")
		elif(current_dir=="left"):
			elec.flip_h=true
			elec.play("walk")	
	elif( !(player_chase ) and player and !(attack)):
		if current_dir=="right":
			elec.flip_h=false
			elec.play("idle")
		elif current_dir=="left":
			elec.flip_h=true
			elec.play("idle")		
	attack1()			
			
		
	
	
	
	
	

func _on_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_chase=true
		player=body


func _on_detection_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_chase=false
		
		
		
		
func decide_direction():
	if (Player.global_position<global_position):
		current_dir="left"
	else :
		current_dir="right"	
		
			


func _on_hit_area_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("Player") and(!(attack)):
		print("player")
		attack=true
		player_chase=false
		


func _on_hit_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		attack=false
		if(abs(Player.global_position-global_position).length()<=80):
			player_chase=true
		else: 
			player_chase=false	
			
			
func attack1():
	
	decide_direction()
	var elec2=$AnimatedSprite2D
	if attack:
		current_att=true
	if attack:
		print($AnimatedSprite2D.frame)
		print("attack")
		if current_dir=="right":
			elec2.flip_h=false
			elec2.play("attack")
			
			
			$cool.start()
		if current_dir=="left"	:
			elec2.flip_h=true
			elec2.play("attack")
			
			
			$cool.start()
							
		



	
func shoot():
	var arrow_temp=arrow.instantiate()
	arrow_temp.direction=(Player.global_position-global_position).normalized()
	
	

	arrow_temp.position=global_position
		
	get_parent().add_child(arrow_temp)
		
	
			
		

	


	
	


func _on_animated_sprite_2d_frame_changed() -> void:
	
	if $AnimatedSprite2D.frame==8 and (attack==true) :
		shoot()
		$AudioStreamPlayer2D.play()
		
		
		
		



	
	
	


func _on_cool_timeout() -> void:
	current_att=false
