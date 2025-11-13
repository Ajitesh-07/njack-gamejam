extends Resource
class_name Item

@export_category("Info")
@export var id: String = ""
@export var display_name: String = "Item"
@export var icon: Texture2D
@export var max_stack: int = 64
@export var description: String = ""

# Optional: is this an equippable, consumable, block, etc
@export var item_type: String = "generic"

# Default use - override in a custom Resource script if needed.
# Should return true if the item was consumed/used (so inventory reduces stack).
func use(user: Node) -> bool:
	return true
