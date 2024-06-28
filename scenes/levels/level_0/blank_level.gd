extends Node2D
class_name BlankLevel

const INIT_BALL_POSITION: Vector2 = Vector2(600, 620)

@onready var ball: Ball = $MainGame/Ball
@onready var top_score_label: Label = $UI/HighScore/CurrentHighScore
@onready var current_score_label: Label = $UI/CurrentScore/Score
@onready var lives_ui: Control = $UI/Lives
@onready var bgm_audio: AudioStreamPlayer = $MainGame/BGM

var bricks_left: int = 0

signal level_finished

func _ready() -> void:
	#starts the level's bgm at -80 and fades it in to -10
	fade_bgm(-10, 1)
	#Connect each brick's signal to update the player's score (see line 21)
	for brick in get_tree().get_nodes_in_group('Bricks'):
		bricks_left += 1
		brick.connect("broken_brick", _on_broken_brick)
	#shows the amount of remaining lives (see line 26)
	current_score_label.text = str(Globals.player_score)
	if(Globals.top_score < Globals.player_score):
		top_score_label.text = str(Globals.player_score)
	update_life_sprites()

func _on_deathzone_body_entered(_body: CharacterBody2D) -> void:
	Globals.is_game_active = false
	ball.speed = 0
	ball.position = INIT_BALL_POSITION
	Globals.player_lives -= 1
	if(Globals.player_lives >= 0):
		update_life_sprites()
	else:
		end_game()

func _on_broken_brick() -> void:
	current_score_label.text = str(Globals.player_score)
	if(Globals.top_score < Globals.player_score):
		top_score_label.text = str(Globals.player_score)
	bricks_left -= 1

func update_life_sprites() -> void:
	#Display the remaining lives
	var life_sprites: int = 0
	for sprite:Sprite2D in lives_ui.get_children():
		sprite.visible = false
		if(life_sprites < Globals.player_lives):
			sprite.visible = true
			life_sprites += 1

func _process(_delta: float) -> void:
	
	if(bricks_left == 0):
		level_finished.emit()
	
	#Enables the colorblind mode
	if(Input.is_action_just_pressed("colorblind_test")):
		Globals.is_colorblind_enabled = !Globals.is_colorblind_enabled
		reset_bricks()
		return

#Since I want to get the _ready function again after (dis)abling the colorblind mode
#I made this method in Brick that just calls the _ready() function
func reset_bricks() -> void:
	for brick: Brick in get_tree().get_nodes_in_group('Bricks'):
		brick.colorblind_enabled()

func end_game() -> void:
	fade_bgm(-80, 1)
	Globals.is_game_active = false

func fade_bgm(volume: int, seconds: float) -> void:
	var tween: Tween = create_tween()
	bgm_audio.play()
	tween.tween_property(bgm_audio, "volume_db", volume, seconds)


