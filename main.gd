# Main
extends Node2D

@export var grodan_scene = preload("res://grodan.tscn")

@export var start_delay = 0

func _ready() -> void:
	await get_tree().create_timer(start_delay).timeout
	
	# Instance Grodan
	var grodan = grodan_scene.instantiate()
	add_child(grodan)
	
	$Door.Exit(grodan)


func _on_lower_portal_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.controllable = false
		# Fix so that grodan can get a speed even when not controllable
		
