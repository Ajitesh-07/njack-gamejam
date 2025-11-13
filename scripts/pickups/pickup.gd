extends Node2D

@export var item_resource: Resource
@onready var animation_sprite = $AnimatedSprite2D
@onready var area2d = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_sprite.play("default")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !body.is_in_group("Player"):
		return
	
	var inv = body.get_node("Inventory")
	if !inv:
		return
	var leftover = inv.add_item(item_resource, 1)
	if leftover == 0:
		queue_free()
