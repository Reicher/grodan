extends CharacterBody2D

@export var walk_speed := 30.0
@export var run_speed := 80.0
@export var jump_velocity := -200.0

var can_climb := false
var is_climbing := false
var is_portaling: bool = false

var has_trumpet := false

@onready var animated_sprite := $AnimatedSprite2D
var controllable := false

func _physics_process(delta: float) -> void:
	if not controllable:
		return

	if is_climbing:
		handle_ladder_movement()
	else:
		handle_ground_movement(delta)
	
	move_and_slide()
	update_animation()

func handle_ladder_movement() -> void:
	# Apply ladder run speed
	var speed = run_speed if Input.is_action_pressed("run") else walk_speed
	velocity = Vector2(0, Input.get_axis("up", "down")) * speed
	
	# Prevent infinite climbing when not near ladder
	if not can_climb:
		end_climbing()
		return

	if is_on_floor() or Input.get_axis("left", "right") != 0:
		end_climbing()

func handle_ground_movement(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity.y += get_gravity().y * delta

	# Jumping
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = jump_velocity

	# Horizontal movement
	velocity.x = Input.get_axis("left", "right") * (run_speed if Input.is_action_pressed("run") else walk_speed)

	# Start climbing only when near ladder
	if can_climb and (Input.is_action_pressed("up") or Input.is_action_pressed("down")):
		start_climbing()

func start_climbing():
	is_climbing = true
	velocity = Vector2.ZERO
	set_collision_mask_value(2, false)

func end_climbing():
	is_climbing = false
	set_collision_mask_value(2, true)

func update_animation() -> void:
	if is_climbing:
		if abs(velocity.y) > 0:
			animated_sprite.play("climb")
		else:
			# Show single frame when stopped
			animated_sprite.play("climb")
			animated_sprite.frame = 0
			animated_sprite.stop()
	elif not is_on_floor():
		animated_sprite.play("jump")
	else:
		animated_sprite.play(
			"idle" if velocity.x == 0 else
			"run" if abs(velocity.x) > walk_speed else
			"walk"
		)
	
	if velocity.x != 0:
		animated_sprite.flip_h = velocity.x > 0

func ExitDoor() -> void:
	animated_sprite.play("exit_door")
	await animated_sprite.animation_finished
	controllable = true

func _on_climb_area_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.is_in_group("climb_area"):
		can_climb = true

func _on_climb_area_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.is_in_group("climb_area"):
		can_climb = false
