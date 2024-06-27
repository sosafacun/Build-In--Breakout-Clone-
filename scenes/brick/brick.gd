extends StaticBody2D

class_name Brick

@export var level: int = 1

var color: Color

@onready var brick_sprite: Sprite2D = get_node("./BrickSprite")
@onready var value: int = level * 100

func _ready() -> void:
	change_color()

func change_color() -> void:
	if(level == 1):
		color = Color('00e9c8')
		brick_sprite.modulate = color
	if(level == 2):
		color = Color('9d20e3')
		brick_sprite.modulate = color
	if(level == 3):
		color = Color('d1aa5b')
		brick_sprite.modulate = color
	if(level == 4):
		color = Color('00b900')

func hit(damage: int) -> void:
	level -= damage
	if(level <= 0):
		Globals.player_score += value
		print('player score', Globals.player_score)
		queue_free()
	else:
		change_color()
