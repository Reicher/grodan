extends Control

@onready var color_rect = $ColorRect
@onready var texture_rect = $TextureRect

# Define the screen type
enum ScreenType { TITLE, GAME_OVER }

@export var screen_type: ScreenType = ScreenType.TITLE

# Color cycling setup
var colors = [
	Color.RED,
	Color.GREEN,
	Color.BLUE,
	Color.YELLOW
]
var color_duration := 0.5
var current_color_index := 0
var color_cycle_done := false

func _ready():
	set_texture_for_screen_type()
	cycle_colors()

func set_texture_for_screen_type():
	match screen_type:
		ScreenType.TITLE:
			texture_rect.texture = load("res://sprites/funnyGames.png")
		ScreenType.GAME_OVER:
			texture_rect.texture = load("res://sprites/gameOver.png")

func cycle_colors():
	if current_color_index < colors.size():
		color_rect.color = colors[current_color_index]
		current_color_index += 1
		await get_tree().create_timer(color_duration).timeout
		cycle_colors()
	else:
		color_cycle_done = true

func _input(event):
	if color_cycle_done and event.is_action_pressed("ui_accept"):
		goto_next_scene()

func goto_next_scene():
	match screen_type:
		ScreenType.TITLE:
			get_tree().change_scene_to_file("res://scenes/level.tscn")
		ScreenType.GAME_OVER:
			get_tree().change_scene_to_file("res://scenes/info_screen.tscn")
