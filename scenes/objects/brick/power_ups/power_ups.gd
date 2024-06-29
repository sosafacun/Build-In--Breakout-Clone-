class_name PowerUp extends Area2D

@export var available_options: Array[String] = [
'longer_paddle', 
'longer_paddle', 
'longer_paddle', 
'super_ball', 
'super_ball', 
'triple_ball',
'extra_life',]


@onready var area: Area2D = $"."
@onready var pos:Vector2 = area.position
#Selects a random power up
@onready var type: String = available_options[randi()%len(available_options)]
#Sprites to show
#el = extra_life
@onready var el_sprite: Sprite2D = $Powers/ExtraLife
#lp = longer_paddle
@onready var lp_sprite: Sprite2D = $Powers/LongerPaddle
#sb = super_ball
@onready var sb_sprite: Sprite2D = $Powers/SuperBall
#sb = triple_ball
@onready var tb_sprite: Sprite2D = $Powers/TripleBall

@export var has_connected: bool = false

signal touched_player

func _ready() -> void:
	if(type == 'longer_paddle'):
		lp_sprite.visible = true
	if(type == 'super_ball'):
		sb_sprite.visible = true
	if(type == 'triple_ball'):
		tb_sprite.visible = true
	if(type == 'extra_life'):
		el_sprite.visible = true

func _process(delta: float) -> void:
	position.y += 200 * delta

func _on_body_entered(_body: CharacterBody2D) -> void:
	touched_player.emit(self)
