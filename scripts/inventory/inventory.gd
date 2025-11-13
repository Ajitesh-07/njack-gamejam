extends Node
class_name Inventory

# number of slots (8 for your hotbar)
@export var slot_count: int = 8

# Each slot is either null or a Dictionary: { "item": Item, "count": int }
var slots: Array = []

signal slot_changed(index:int)  # emitted when slot contents change
signal item_used(index:int)     # when use requested (UI -> model)

signal selection_changed(new_index: int) # <--- ADD THIS

var selected_index = 0

func _ready():
	_init_slots()

func _init_slots():
	slots.resize(slot_count)
	for i in range(slot_count):
		slots[i] = null

# Add item, stack if possible. Returns leftover count (0 if fully added).
func add_item(item: Item, count: int = 1) -> int:
	if not item:
		return count

	var leftover = count

	# first try stacking into existing stacks
	for i in range(slot_count):
		var s = slots[i]
		if s and s.item == item and s.count < item.max_stack:
			var can_add = min(leftover, item.max_stack - s.count)
			s.count += can_add
			leftover -= can_add
			emit_signal("slot_changed", i)
			if leftover == 0:
				return 0

	# then fill empty slots
	for i in range(slot_count):
		if leftover == 0:
			break
		if not slots[i]:
			var put = min(leftover, item.max_stack)
			slots[i] = {"item": item, "count": put}
			leftover -= put
			emit_signal("slot_changed", i)

	return leftover  # leftover > 0 means inventory full for that many

# Remove count from a slot. If becomes zero, set to null
func remove_from_slot(index:int, count:int) -> bool:
	if index < 0 or index >= slot_count:
		return false
	var s = slots[index]
	if not s:
		return false
	if count >= s.count:
		slots[index] = null
	else:
		s.count -= count
	emit_signal("slot_changed", index)
	return true

# Use an item in a slot (calls item.use(user)), if used returns true and decrement
func use_item(index:int, user: Node) -> bool:
	if index < 0 or index >= slot_count:
		return false
	var s = slots[index]
	if not s:
		return false
	var item: Item = s.item
	# Call the item use behavior — item decides whether it consumes itself
	var consumed := item.use(user)
	if consumed:
		remove_from_slot(index, 1)
	emit_signal("item_used", index)
	return consumed

# Helper to get slot snapshot
func get_slot(index:int):
	if index < 0 or index >= slot_count:
		return null
	return slots[index]

func set_selected_index(idx: int):
	if idx < 0 or idx >= slot_count:
		return # Ignore invalid index
	if selected_index == idx:
		return # No change
		
	selected_index = idx
	emit_signal("selection_changed", selected_index)

# This function just returns the value. (Removed the unused 'idx' parameter)
func get_selected_index() -> int:
	return selected_index
