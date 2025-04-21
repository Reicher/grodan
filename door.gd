extends AnimatedSprite2D


func Exit(entity):
	play("red_open")

	# Position entity at the door
	entity.global_position = global_position + Vector2(2, 2) 

	# Tell entity to play exit animation
	entity.ExitDoor()
