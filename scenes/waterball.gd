extends Area2D


var speed=300
var direction=Vector2.ZERO
func _physics_process(delta: float) -> void:
	global_position+=speed*direction*delta
	rotation=direction.angle()
	
