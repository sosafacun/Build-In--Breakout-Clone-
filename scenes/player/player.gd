extends CharacterBody2D

class_name Player

const IS_PADDLE: bool = true

@export var speed: int

func _process(_delta: float) -> void:
	
	#Basic movement
	var direction: Vector2 = Vector2.ZERO
	
	if(Input.is_action_pressed("move_left")):
		direction = Vector2.LEFT
	if(Input.is_action_pressed("move_right")):
		direction = Vector2.RIGHT
	
	velocity = direction * speed
	move_and_slide()
	Globals.player_position = position
	
	#If the player presses "O" (the letter o) the colorblind mode will be enabled or disabled
