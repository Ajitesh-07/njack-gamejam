extends Control
class_name InventorySlot

@export var slot_index: int = 0
@export var is_selected: bool = false: set = set_selected
@onready var selectedNode: Node = $SelectedVersion
@onready var unselectedNode: Node = $UnselectedNode
@onready var selectedIconNode = $SelectedVersion/TextureRect
@onready var unselectedIconNode = $UnselectedNode/TextureRect
@onready var selectedLabelNode = $SelectedVersion/Label
@onready var unselectedLabelNode = $UnselectedNode/Label

# These old variables are no longer needed, as we have selected/unselected versions
# var icon_node: TextureRect
# var count_label: Label

signal right_clicked(index:int)
signal left_clicked(index:int)

func _ready():	
	# This is good. It ensures the UI is blank to start
	update_slot(null) 
	
	# Set initial visual state based on is_selected default (false)
	set_selected(is_selected)

func update_slot(data):
	# data is either null or {"item": Item, "count": int}
	if not data:
		selectedIconNode.texture = null # Clear texture if empty
		unselectedIconNode.texture = null
		selectedLabelNode.text = ""
		unselectedLabelNode.text = ""
	else:
		selectedIconNode.texture = data.item.icon # Set texture
		unselectedIconNode.texture = data.item.icon
		selectedLabelNode.text = str(data.count)
		unselectedLabelNode.text = str(data.count)

# This function is perfect.
func set_selected(value: bool):
	is_selected = value
	if selectedNode and unselectedNode:
		selectedNode.visible = is_selected
		unselectedNode.visible = not is_selected

# This is also perfect for our manager UI system.
func _unhandled_input(event: InputEvent):
	if !is_selected:
		return
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MouseButton.MOUSE_BUTTON_RIGHT:
			emit_signal("right_clicked", slot_index)
		elif event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			emit_signal("left_clicked", slot_index)
