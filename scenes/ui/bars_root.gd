extends Control

@export var max_health: float = 100.0
@export var max_armor: float = 100.0
@export var playerPath: NodePath = "Player"

var current_health: float = 10.0
var current_armor: float = 0.0

func _ready() -> void:
	$HealthRow/HealthBar.max_value = max_health
	$ArmorRow/ArmorBar.max_value = max_armor
	$HealthRow/HealthBar.value = current_health
	$ArmorRow.visible = false
	
	var player = get_tree().get_nodes_in_group("Player")[0]
	if player:
		print("Found Player")
		player.connect("health_changed", Callable(self, "set_health"))

func set_health(new_health: float) -> void:
	new_health = clamp(new_health, 0.0, max_health)
	print("Reached here", current_health, new_health)
	current_health = new_health  # store it
	create_tween().tween_property($HealthRow/HealthBar, "value", new_health, 0.22).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	if $HealthRow.has_node("HealthLabel"):
		$HealthRow.get_node("HealthLabel").text = str(int(new_health)) + " / " + str(int(max_health))

func set_armor(new_armor: float) -> void:
	new_armor = clamp(new_armor, 0.0, max_armor)
	current_armor = new_armor  # store it
	$ArmorRow.visible = new_armor > 0.0
	create_tween().tween_property($ArmorRow/ArmorBar, "value", new_armor, 0.18).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	if $ArmorRow.has_node("ArmorLabel"):
		$ArmorRow.get_node("ArmorLabel").text = str(int(new_armor)) + " / " + str(int(max_armor))
