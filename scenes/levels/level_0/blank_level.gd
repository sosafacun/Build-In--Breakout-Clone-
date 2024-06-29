extends Node2D
class_name BlankLevel

const INIT_BALL_POSITION: Vector2 = Vector2(600, 620)

@onready var ball: Ball = $MainGame/Ball
@onready var top_score_label: Label = $UI/HighScore/CurrentHighScore
@onready var current_score_label: Label = $UI/CurrentScore/Score
@onready var lives_ui: Control = $UI/Lives
@onready var bgm_audio: AudioStreamPlayer = $MainGame/BGM
#pu_node = PowerUpNode
@onready var pu_node: Node2D = $MainGame/Bricks/PowerUps

@onready var power_up: PackedScene = preload("res://scenes/objects/brick/power_ups/power_ups.tscn")
@onready var pu_effects: PowerUpEffects = PowerUpEffects.new()

var bricks_left: int = 0

signal level_finished

func _ready() -> void:
	#starts the level's bgm at -80 and fades it in to -10
	fade_bgm(-10, 1)
	#Connect each brick's signal to update the player's score
	#And sets the power ups
	for brick: Brick in get_tree().get_nodes_in_group('Bricks'):
		bricks_left += 1
		brick.connect("broken_brick", _on_broken_brick)
	
	current_score_label.text = str(Globals.player_score)
	if(Globals.top_score < Globals.player_score):
		top_score_label.text = str(Globals.player_score)
	update_life_sprites()


func _on_player_collects_power_up(pu: PowerUp) -> void:
	if(pu.type == 'longer_paddle'):
		pu_effects.long_player(pu)
	if(pu.type == 'super_ball'):
		pu_effects.super_balls(pu)
	if(pu.type == 'triple_ball'):
		pu_effects.add_balls(pu)
	if(pu.type == 'extra_life'):
		pu_effects.add_player_life(pu)

#Whenever a brick is broken
func _on_broken_brick(brick: Brick) -> void:
	current_score_label.text = str(Globals.player_score)
	bricks_left -= 1
	#updates top score as well as current score if current is the newest top score
	if(Globals.top_score < Globals.player_score):
		top_score_label.text = str(Globals.player_score)
	#if a brick has a power up it will drop it
	if(brick.has_surprise):
		var new_power_up:PowerUp = power_up.instantiate() as Area2D
		new_power_up.position = brick.global_position
		pu_node.add_child(new_power_up)


#TODO: if player grabs a +1 power up this should also be called
func update_life_sprites() -> void:
	#Display the remaining lives
	var life_sprites: int = 0
	for sprite:Sprite2D in lives_ui.get_children():
		sprite.visible = false
		if(life_sprites < Globals.player_lives):
			sprite.visible = true
			life_sprites += 1


#process is used to (de)activate colorblind mode and to see if all the bricks have been destroyed
func _process(_delta: float) -> void:
	
	if(bricks_left == 0):
		level_finished.emit()
	
	#Enables the colorblind mode
	if(Input.is_action_just_pressed("colorblind_test")):
		Globals.is_colorblind_enabled = !Globals.is_colorblind_enabled
		reset_bricks()
		return
	
	if(pu_node.get_child_count() > 0):
		for pu:PowerUp in get_tree().get_nodes_in_group('PowerUps'):
			if(!pu.has_connected):
				pu.has_connected = true
				pu.connect('touched_player', _on_player_collects_power_up)


#Since I want to get the _ready function again after (dis)abling the colorblind mode
#I made this method in Brick that just calls the _ready() function
func reset_bricks() -> void:
	for brick: Brick in get_tree().get_nodes_in_group('Bricks'):
		brick.colorblind_enabled()


#TODO: implement EndScreen menu to call from here
func end_game() -> void:
	fade_bgm(-80, 1)
	Globals.is_game_active = false


#fades in or out the bgm
func fade_bgm(volume: int, seconds: float) -> void:
	var tween: Tween = create_tween()
	bgm_audio.play()
	tween.tween_property(bgm_audio, "volume_db", volume, seconds)


#deathzone. calls queue_free() on either the power ups or the balls
func _on_deathzone_area_entered(area: Area2D) -> void:
	area.queue_free()


func _on_deathzone_body_entered(_body: Variant) -> void:
	Globals.is_game_active = false
	ball.speed = 0
	ball.position = INIT_BALL_POSITION
	Globals.player_lives -= 1
	if(Globals.player_lives >= 0):
		update_life_sprites()
	else:
		end_game()


