# Main
extends Node2D

@export var grodan_scene = preload("res://grodan.tscn")
@export var start_delay = 0

@onready var upper_portal = $"Upper Plattform/Portal"
@onready var lower_portal = $"Lower Plattform/Portal"

func _ready() -> void:
	upper_portal.set_portal_pair(lower_portal)
	lower_portal.set_portal_pair(upper_portal)
	
	await get_tree().create_timer(start_delay).timeout
	
	# Instance Grodan
	var grodan = grodan_scene.instantiate()
	add_child(grodan)
	
	$Door.Exit(grodan)
