extends CharacterBody2D

@export var speed = 150.0

@onready var animated_sprite = $AnimatedSprite2D

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
