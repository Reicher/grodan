extends CharacterBody2D

@export var speed: float = 75
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
var target: CharacterBody2D
	
func set_target(new_target) -> void:
	target = new_target
	# Update path every 0.35 seconds for performance
	$PathUpdateTimer.start(0.1)

func _physics_process(delta: float) -> void:
	if !target: return
	
	# Calculate movement
	var next_target = nav_agent.get_next_path_position()
	var direction = global_position.direction_to(next_target)
	velocity = direction * speed
	print(next_target)
	move_and_slide()
	
	# Update animations based on movement
	update_animations(direction)

func update_animations(dir: Vector2):
	$AnimatedSprite2D.flip_h = dir.x < 0
	if velocity.length() > 5.0:
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")

func _on_path_update_timer_timeout() -> void:
	if target:
		nav_agent.target_position = target.global_position
