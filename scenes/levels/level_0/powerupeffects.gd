class_name PowerUpEffects extends Level

func add_player_life(pu: PowerUp) -> void:
	Globals.player_lives += 1
	super.update_life_sprites()
	pu.queue_free()

func add_balls(pu: PowerUp) -> void:
	pu.queue_free()

func super_balls(pu: PowerUp) -> void:
	pu.queue_free()

func long_player(pu: PowerUp) -> void:
	pu.queue_free()
