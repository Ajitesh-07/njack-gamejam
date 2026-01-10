extends Control

func _ready():
	visible = false # Hide automatically when game starts

func open():
	visible = true # Show when called

func _on_close_button_pressed():
	visible = false # Hide when X is clicked
