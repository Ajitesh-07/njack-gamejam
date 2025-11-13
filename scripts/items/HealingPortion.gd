extends Item
class_name HealingPotion

@export var heal_amount:int = 10

func use(user: Node) -> bool:
	if user and user.has_method("apply_heal"):
		user.apply_heal(heal_amount)
		return true
	return false
