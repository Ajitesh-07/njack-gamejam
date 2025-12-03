extends Control

var next_scene_path := "res://scenes/firetemplev_2.tscn"

@onready var label = $Panel/Label

func ask(question_text: String, scene_path: String):
	label.text = question_text
	next_scene_path = scene_path
	visible = true

func _on_yes_pressed():
	get_tree().change_scene_to_file(next_scene_path)

func _on_no_pressed():
	visible = false
