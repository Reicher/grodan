extends CharacterBody2D

@export var walk_speed := 30.0
@export var run_speed := 60.0
@export var jump_velocity := -200.0

@onready var animated_sprite := $AnimatedSprite2D
var controllable := true

func _physics_process(delta: float) -> void:
	if not controllable:
		return

	if not is_on_floor():
		velocity.y += get_gravity().y * delta

	handle_input()
	move_and_slide()
	update_animation()

func handle_input() -> void:
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = jump_velocity

	var input_dir = Input.get_axis("left", "right")
	var run_modifier = Input.get_action_strength("run")
	
	velocity.x = input_dir * (run_speed if run_modifier else walk_speed)

func update_animation() -> void:
	if not is_on_floor():
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
	controllable = false
	animated_sprite.play("exit_door")
	await animated_sprite.animation_finished
	controllable = true
