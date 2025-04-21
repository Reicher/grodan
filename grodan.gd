extends CharacterBody2D

@export var walk_speed := 30.0
@export var run_speed := 80.0
@export var jump_velocity := -200.0

var is_near_ladder := false
var is_climbing := false

@onready var animated_sprite := $AnimatedSprite2D
var controllable := false

func _physics_process(delta: float) -> void:
	if not controllable:
		return

	# Climbing
	if is_climbing:
		handle_ladder_input()
	else:
		if not is_on_floor():
			velocity.y += get_gravity().y * delta
		handle_input()

	move_and_slide()
	update_animation()
	
func handle_ladder_input() -> void:
	var up_down = Input.get_axis("up", "down")
	velocity.y = up_down * walk_speed
	velocity.x = 0

	# Stop climbing if jumping or walking away
	if not is_near_ladder or is_on_floor():
		is_climbing = false

func handle_input() -> void:
	# Jump
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = jump_velocity

	# Normal walking
	var input_dir = Input.get_axis("left", "right")
	var run_modifier = Input.get_action_strength("run")
	velocity.x = input_dir * (run_speed if run_modifier else walk_speed)

	# Start climbing if pressing up/down and near a ladder
	if is_near_ladder:
		if Input.is_action_pressed("up") or (Input.is_action_pressed("down") and not is_on_floor()):
			is_climbing = true
			velocity.x = 0

func update_animation() -> void:
	if is_climbing:
		if velocity.y == 0:
			animated_sprite.play("climb")
			animated_sprite.frame = 0  # freeze on first frame
		else:
			animated_sprite.play("climb")
	elif not is_on_floor():
		animated_sprite.play("jump")
	elif velocity.x == 0:
		animated_sprite.play("idle")
	elif abs(velocity.x) <= walk_speed:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("run")

	if velocity.x != 0:
		animated_sprite.flip_h = velocity.x > 0

func ExitDoor() -> void:
	animated_sprite.play("exit_door")
	await animated_sprite.animation_finished
	controllable = true
