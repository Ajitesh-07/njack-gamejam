extends Item
class_name FireballAttack

# This item's specific 'use' behavior.
# It tells the 'user' (the Player) to cast a fireball.
func use(user: Node) -> bool:
	# Check if the node using this item has a 'cast_fireball' function
	if user.has_method("cast_fireball"):
		user.cast_fireball()
		return true # Yes, this item was consumed
	else:
		print("ERROR: ", user.name, " tried to use a FireballItem but has no 'cast_fireball' method.")
		return false
