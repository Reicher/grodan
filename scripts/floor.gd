extends StaticBody2D

@onready var shape = $CollisionShape2D
@onready var rect = $ColorRect

func _ready():
	var new_shape = RectangleShape2D.new()
	new_shape.size = rect.size
	shape.shape = new_shape
	shape.position = rect.size / 2
