extends Control

@onready var color_rect = $ColorRect
@onready var color_duration_timer := $ColorDuration

@export var next_scene := "" # Set in the inherited scene

# Color cycling setup
var colors = [
	Color.SEA_GREEN,
	Color.DARK_ORANGE,
	Color.SKY_BLUE,
	Color8(0xE2, 0x7D, 0x84), # Pink
	Color.SEA_GREEN,
	Color.DARK_ORANGE,
	Color.SKY_BLUE,
	Color.YELLOW
]

var current_color_index := 0
func _ready():
	color_rect.color = colors[current_color_index]
	current_color_index += 1

func cycle_colors():
	if current_color_index < colors.size():
		color_rect.color = colors[current_color_index]
		current_color_index += 1
		color_duration_timer.start()
	else:
		get_tree().change_scene_to_file(next_scene)

func _on_color_duration_timeout() -> void:
	cycle_colors()
	
