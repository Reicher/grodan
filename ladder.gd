extends Area2D

# On the Area2D
func _on_body_entered(body):
	if body is CharacterBody2D:
		body.is_near_ladder = true

func _on_body_exited(body):
	if body is CharacterBody2D:
		body.is_near_ladder = false
