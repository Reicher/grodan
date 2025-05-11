extends CharacterBody2D

@export var speed: float = 35
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
var target: CharacterBody2D
var dying := false
	
func set_target(new_target) -> void:
	target = new_target
	# Update path every 0.35 seconds for performance
	$PathUpdateTimer.start(0.1)

func _physics_process(delta: float) -> void:
	if !target or dying:
		return

	# Movement
	var next_target = nav_agent.get_next_path_position()
	var direction = global_position.direction_to(next_target)
	velocity = direction * speed

	var collision_count = move_and_slide()

	# Check if Grodan have been caught!
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider().name == "Grodan":
			game_over()

	# Update animations
	update_animations(direction)


func game_over() -> void:
	var game_over_scene = preload("res://scenes/game_over.tscn")
	var game_over_screen = game_over_scene.instantiate()
	
	# Remove current scene
	get_tree().current_scene.queue_free()

	# Add the new screen directly to the root viewport
	get_tree().root.add_child(game_over_screen)
	

func update_animations(dir: Vector2):
	$AnimatedSprite2D.flip_h = dir.x > 0
	if velocity.length() > 5.0:
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")

func _on_path_update_timer_timeout() -> void:
	if target:
		nav_agent.target_position = target.global_position
		
func die() -> void:
	dying = true
	$AnimatedSprite2D.play("die")
	$AnimatedSprite2D.animation_finished.connect(func(): queue_free())
