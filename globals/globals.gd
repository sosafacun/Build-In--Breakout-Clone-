extends Node

#for pong_bounce in ball scene
#REMEMBER TO CHANGE THIS AFTER CHANGING THE PLACEHOLDER PLAYER
const PLAYER_WIDTH: float = 107

#General game status tracking
var is_game_active: bool = false
var is_colorblind_enabled: bool = false

#to track stats and possible changes
var ball_damage: int
var ball_amount: int
var ball_position: Vector2
var player_position: Vector2
var player_lives: int:
	set(value):
		player_lives = min(value, 6)

var top_score: int

#scores
var player_score: int

func _ready() -> void:
	player_lives = 3
