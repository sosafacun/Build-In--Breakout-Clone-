extends StaticBody2D

class_name Brick

@export var level: int = 1

@onready var brick_sprite: Sprite2D = get_node("./BrickSprite")
@onready var value: int = level * 100
@onready var hp_label: Label = get_node("./HPLabel")

signal broken_brick

func _ready() -> void:
	hp_label.visible = Globals.is_colorblind_enabled
	change_color()

func change_color() -> void:
	if(level == 1):
		brick_sprite.modulate = Color('00e9c8')
		hp_label.text = str(level)
	if(level == 2):
		brick_sprite.modulate = Color('9d20e3')
		hp_label.text = str(level)
	if(level == 3):
		brick_sprite.modulate = Color('d1aa5b')
		hp_label.text = str(level)
	if(level == 4):
		brick_sprite.modulate = Color('00b900')
		hp_label.text = str(level)

func hit(damage: int) -> void:
	level -= damage
	if(level <= 0):
		Globals.player_score += value
		broken_brick.emit()
		queue_free()
	else:
		change_color()

#Calls the _ready() function again to turn on/off the colorblind mode
func colorblind_enabled() -> void:
	_ready()

func has_suprise() -> bool:
	if(randi_range(1,20) % 20 == 0):
		return true
	else:
		return false
