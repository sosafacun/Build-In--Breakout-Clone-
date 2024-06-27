extends Node

#for pong_bounce in ball scene
#REMEMBER TO CHANGE THIS AFTER CHANGING THE PLACEHOLDER PLAYER
const PLAYER_WIDTH: float = 630

#to track is the game is active, or not
var is_game_active: bool = false

#to track stats and possible changes
var ball_position: Vector2
var player_position: Vector2

#scores
var player_score: int
