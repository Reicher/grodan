extends Sprite2D

func _on_climb_area_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.is_near_ladder = true

func _on_climb_area_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.is_near_ladder = false
