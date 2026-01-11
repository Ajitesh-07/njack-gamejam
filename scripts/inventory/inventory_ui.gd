extends Control

@export var player_node_path: NodePath
var player: Node
var inventory: Node
var slot_nodes: Array = []
var selected_index = 0

func _ready():
	# 1. Find the Player (We still need this to know who uses the items)
	var found_players = get_tree().get_nodes_in_group("Player")
	if found_players.size() > 0:
		player = found_players[0]
	else:
		print("InventoryUI: Could not find Player!")
		return

	# 2. CONNECT TO THE GLOBAL AUTOLOAD
	# Instead of searching for a child node, we just point to the Singleton.
	inventory = GlobalInventory 

	# 3. Gather slots
	var hbox = $CenterContainer/HBoxContainer
	for i in range(hbox.get_child_count()):
		var slot = hbox.get_child(i)
		slot.slot_index = i
		
		# Disconnect old signals if any (safety check)
		if slot.is_connected("right_clicked", Callable(self, "_on_slot_right_clicked")):
			slot.disconnect("right_clicked", Callable(self, "_on_slot_right_clicked"))
		if slot.is_connected("left_clicked", Callable(self, "_on_slot_left_clicked")):
			slot.disconnect("left_clicked", Callable(self, "_on_slot_left_clicked"))
			
		slot.connect("right_clicked", Callable(self, "_on_slot_right_clicked"))
		slot.connect("left_clicked", Callable(self, "_on_slot_left_clicked"))
		slot_nodes.append(slot)

	# 4. Connect Signals
	# We check if we are already connected to avoid errors when reloading
	if not inventory.is_connected("slot_changed", Callable(self, "_on_slot_changed")):
		inventory.connect("slot_changed", Callable(self, "_on_slot_changed"))
		
	if not inventory.is_connected("selection_changed", Callable(self, "_on_selection_changed")):
		inventory.connect("selection_changed", Callable(self, "_on_selection_changed"))
		
	# 5. Refresh UI
	_refresh_all()
	# Sync the selection from the Global data
	_on_selection_changed(inventory.get_selected_index())

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
			get_viewport().set_input_as_handled()
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
