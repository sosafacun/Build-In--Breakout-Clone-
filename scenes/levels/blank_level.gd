extends Node2D

const INIT_BALL_POSITION: Vector2 = Vector2(600, 620)

@onready var ball: Ball = get_node("./MainGame/Ball")
@onready var top_score: Label = get_node("./UI/HighScore/CurrentHighscore")
@onready var current_score_label: Label = get_node("./UI/CurrentScore/Score")
@onready var lives_ui: Control = get_node("./UI/Lives")

func _ready() -> void:
	#Connect each brick's signal to update the player's score (see line 21)
	for brick in get_tree().get_nodes_in_group('Bricks'):
		brick.connect("broken_brick", _on_broken_brick)
	#shows the amount of remaining lives (see line 26)
	update_life_sprites()
	
func _on_deathzone_body_entered(_body: CharacterBody2D) -> void:
	Globals.is_game_active = false
	ball.speed = 0
	ball.position = INIT_BALL_POSITION
	Globals.player_lives -= 1
	update_life_sprites()

func _on_broken_brick() -> void:
	current_score_label.text = str(Globals.player_score)

func update_life_sprites() -> void:
	#Display the remaining lives
	var life_sprites: int = 0
	for sprite:Sprite2D in lives_ui.get_children():
		sprite.visible = false
		if(life_sprites < Globals.player_lives):
			sprite.visible = true
			life_sprites += 1

func _process(_delta: float) -> void:
	
	#Enables the colorblind mode
	if(Input.is_action_just_pressed("colorblind_test") 
	and Globals.is_colorblind_enabled == false):
		Globals.is_colorblind_enabled = true
		print('enabled')
		reset_bricks()
		return
	
	#Disabled the colorblind mode
	if(Input.is_action_just_pressed("colorblind_test") 
	and Globals.is_colorblind_enabled == true):
		Globals.is_colorblind_enabled = false
		print('disabled')
		reset_bricks()
		return

#Since I want to get the _ready function again after (dis)abling the colorblind mode
#I made this method in Brick that just calls the _ready() function
func reset_bricks() -> void:
	for brick: Brick in get_tree().get_nodes_in_group('Bricks'):
		brick.colorblind_enabled()
