extends Area2D

@export var next_scene : String
@export var temple_name : String = "Temple"

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name == "Player":
		var question = "Do you want to enter the " + temple_name + "?"
		get_tree().current_scene.get_node("CanvasLayer/TemplePopup").ask(question, next_scene)
