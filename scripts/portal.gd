extends Node2D

@onready var left = $Left
@onready var entry = $Entry
@onready var entry_point = $Entry/Point

var portal_pair: Node2D = null

var active: bool = false

func _ready():
	await get_tree().create_timer(0.5).timeout
	active = portal_pair != null

func set_portal_pair(portal: Node2D) -> void:
	portal_pair = portal

func _on_entry_body_entered(body: Node2D) -> void:
	if not active or body is not CharacterBody2D:
		return
	
	if body.is_portaling:
		return  # Already in a portal transition

	body.is_portaling = true

	if body.has_method("set_control_enabled"):
		body.set_control_enabled(false)

	var entry_pos = entry_point.global_position
	var left_pos = left.global_position
	var tween = get_tree().create_tween()
	tween.tween_property(body, "global_position", left_pos, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	await tween.finished

	# Teleport to destination portal
	var pair_entry = portal_pair.get_node("Entry/Point")
	var pair_left = portal_pair.get_node("Left")
	body.global_position = pair_left.global_position
	
	# Flip sprite
	if body.has_node("AnimatedSprite2D"):
		var sprite = body.get_node("AnimatedSprite2D")
		sprite.flip_h = not sprite.flip_h

	var tween_out = get_tree().create_tween()
	tween_out.tween_property(body, "global_position", pair_entry.global_position, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	await tween_out.finished

	if body.has_method("set_control_enabled"):
		body.set_control_enabled(true)

func _on_entry_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.is_portaling = false
