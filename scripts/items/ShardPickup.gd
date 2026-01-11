extends Item
class_name ShardPickup

# This item's specific 'use' behavior.
# It tells the 'user' (the Player) to cast a fireball.
func use(user: Node) -> bool:
	return false
