extends Control

@export var player_node_path: NodePath
var player: Node
var inventory: Node
var slot_nodes: Array = []
var selected_index = 0

func _ready():
	# get player
	if player_node_path != NodePath(""):
		player = get_node(player_node_path)
	else:
		# fallback common path (adjust "Main/Player" to your root/Player path)
		if has_node("/root/Main/Player"):
			player = get_node("/root/Main/Player")

	# find inventory (child of player) or autoload fallback
	if player and player.has_node("Inventory"):
		inventory = player.get_node("Inventory")
	elif get_tree().has_node("/root/Inventory"):
		inventory = get_tree().get_node("/root/Inventory")

	# gather slots (assumes CenterContainer/HBoxContainer/Slots)
	var hbox = $CenterContainer/HBoxContainer
	for i in range(hbox.get_child_count()):
		var slot = hbox.get_child(i)
		slot.slot_index = i
		slot.connect("right_clicked", Callable(self, "_on_slot_right_clicked"))
		slot.connect("left_clicked", Callable(self, "_on_slot_left_clicked"))
		slot_nodes.append(slot)

	if inventory:
		inventory.connect("slot_changed", Callable(self, "_on_slot_changed"))
		inventory.connect("selection_changed", Callable(self, "_on_selection_changed"))
		_refresh_all()
		# Set the initial visual selection based on the data model's default
		_on_selection_changed(inventory.get_selected_index())
	else:
		push_warning("Inventory not found - set player_node_path or create autoload Inventory.")

func _unhandled_input(event: InputEvent):
	# Don't do anything if the inventory data model isn't linked
	if not inventory:
		return

	# We only care about mouse wheel scrolling
	if event is InputEventMouseButton and event.pressed:
		# Get the current state from our data model
		var current_index: int = inventory.get_selected_index()
		var slot_count: int = inventory.slot_count
		var new_index: int = current_index # Default to no change
		
		var changed: bool = false

		if event.button_index == MouseButton.MOUSE_BUTTON_WHEEL_DOWN:
			# Scroll down (move selection to the right)
			# The % (modulo) operator makes it wrap around from 7 back to 0
			new_index = (current_index + 1) % slot_count
			changed = true
			
		elif event.button_index == MouseButton.MOUSE_BUTTON_WHEEL_UP:
			# Scroll up (move selection to the left)
			# The + slot_count handles negative numbers before the modulo
			new_index = (current_index - 1 + slot_count) % slot_count
			changed = true

		if changed:
			# Tell the data model to update
			inventory.set_selected_index(new_index)
			
			# Stop this scroll event from bubbling up (e.g., zooming the camera)
			# It's like a bouncer at a club: "You're done here."

func _on_slot_changed(index:int):
	_refresh_slot(index)

func _refresh_slot(index:int):
	var data = inventory.get_slot(index) if inventory else null
	slot_nodes[index].update_slot(data)

func _refresh_all():
	for i in range(slot_nodes.size()):
		_refresh_slot(i)

func _on_slot_right_clicked(index:int):
	if inventory and player:
		inventory.use_item(index, player)

func _on_slot_left_clicked(index:int):
	# optional select logic
	pass

func _on_selection_changed(new_index: int):
	# Update our local variable
	selected_index = new_index
	
	# Loop through all visual slot nodes
	for i in range(slot_nodes.size()):
		var slot_node = slot_nodes[i]
		# Use a simple boolean comparison to set the state
		# If i == new_index, this is true. Otherwise, it's false.
		slot_node.is_selected = (i == new_index)
