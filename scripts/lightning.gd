extends Area2D
@onready var Player=get_node("../Player")

var light_cool=true
var direction=Vector2.ZERO
func _physics_process(delta: float) -> void:

	
	$AnimatedSprite2D.rotation=direction.angle()
	if light_cool:
		$AnimatedSprite2D.play("effect")
		light_cool=false
		$light_timer.start()
		
	
		

	




func _on_animated_sprite_2d_animation_finished() -> void:
	
	queue_free()
	pass


func _on_light_timer_timeout() -> void:
	light_cool=true
	
