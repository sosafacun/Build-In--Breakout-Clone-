class_name BlankLevel extends Node2D

const INIT_BALL_POSITION: Vector2 = Vector2(600, 620)

@onready var main_ball: Ball = $MainGame/Balls/Ball
@onready var balls_node: Node2D = $MainGame/Balls
@onready var top_score_label: Label = $UI/HighScore/CurrentHighScore
@onready var current_score_label: Label = $UI/CurrentScore/Score
@onready var lives_ui: Control = $UI/Lives
@onready var bgm_audio: AudioStreamPlayer = $MainGame/BGM
#pu_node = PowerUpNode
@onready var pu_node: Node2D = $MainGame/Bricks/PowerUps

@onready var power_up: PackedScene = preload("res://scenes/objects/brick/power_ups/power_ups.tscn")
var bricks_left: int = 0

signal level_finished
signal life_lost

func _ready() -> void:
	
	Globals.ball_amount = 1
	print('ready Ball amount: ', Globals.ball_amount)
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
	var pu_effects: PowerUpEffects = PowerUpEffects.new(pu)
	
	#Makes the player and their hitbox larger
	if(pu.type == 'longer_paddle'):
		pu_effects.long_player()
		return
	#Makes **ALL** the balls deal 2 damage to the blocks
	if(pu.type == 'super_ball'):
		for balls: Ball in get_tree().get_nodes_in_group('Balls'):
			pu_effects.super_balls(balls)
		return
	#Adds 2 more balls
	if(pu.type == 'triple_ball'):
		balls_node.add_child(pu_effects.add_ball())
		balls_node.add_child(pu_effects.add_ball())
		pu.queue_free()
		return
	#Adds one extra life to the player
	if(pu.type == 'extra_life'):
		pu_effects.add_player_life()
		update_life_sprites()
		return

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
	for ball: Ball in get_tree().get_nodes_in_group('Balls'):
		if (ball.is_main_ball):
			Globals.ball_position = ball.position
	
	if(bricks_left == 0):
		level_finished.emit()
	
	#Enables the colorblind mode
	if(Input.is_action_just_pressed("colorblind_test")):
		Globals.is_colorblind_enabled = !Globals.is_colorblind_enabled
		reset_bricks()
		return
	
	if(pu_node.get_child_count() > 0 and Globals.is_game_active):
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
func _on_deathzone_area_entered(area: PowerUp) -> void:
	area.queue_free()


#TO HANDLE MULTIPLE BALLS AT THE SAME TIME:
#1) Spawn them balls -> DONE
#2) Have ONE that's the main ball to get the position for Global.Position
#3) If the main ball reaches the zone, pick the one that's the furthest away from the player for it to be the main ball
#4) Once decided on a new main ball, queue_free the old mainball##

func _on_deathzone_body_entered(ball: Ball) -> void:
	Globals.ball_amount -= 1
	if(ball.is_main_ball):
		if(balls_node.get_child_count() >= 2):
			select_new_ball(ball)
		if(Globals.ball_amount <= 0):
			life_lost.emit()
			return
	else:
		ball.queue_free()

func select_new_ball(ball: Ball) -> void:
	var new_main_ball: Ball = Ball.new()
	new_main_ball.position.y = Globals.ball_position.y
	for balls: Ball in get_tree().get_nodes_in_group('Balls'):
		if(balls.position.y < new_main_ball.position.y):
			new_main_ball = balls
	new_main_ball.is_main_ball = true
	main_ball = new_main_ball
	ball.queue_free()

func _on_life_lost() -> void:
	Globals.is_game_active = false
	main_ball.speed = 0
	main_ball.position = INIT_BALL_POSITION
	Globals.player_lives -= 1
	update_life_sprites()
	Globals.ball_amount = 1
