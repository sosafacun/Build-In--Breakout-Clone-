class_name PowerUpEffects

var pu: PowerUp

func _init(pu_di: PowerUp) -> void:
	pu = pu_di

func add_player_life() -> void:
	Globals.player_lives += 1
	pu.queue_free()

func add_ball() -> Ball:
	var ball: Ball = preload("res://scenes/objects/ball/ball.tscn").instantiate()
	ball.position = Globals.ball_position
	ball.damage = Globals.ball_damage
	Globals.ball_amount += 1
	ball.set_starting_velocity()
	return ball

func super_balls(ball: Ball) -> void:
	ball.damage = 2
	Globals.ball_damage = 2
	pu.queue_free()

func long_player() -> void:
	pu.queue_free()
