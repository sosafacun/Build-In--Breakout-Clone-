extends Node2D

const INIT_BALL_POSITION: Vector2 = Vector2(600, 620)
@onready var ball: Ball = get_node("./Ball")

func _on_deathzone_body_entered(_body: CharacterBody2D) -> void:
	Globals.is_game_active = false
	ball.speed = 0
	ball.position = INIT_BALL_POSITION
