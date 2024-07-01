extends CharacterBody2D

class_name Ball

@export var speed: float
@export var damage: int
@export var is_main_ball: bool = false
var start_speed: float = 15
var collision_info : KinematicCollision2D

@onready var normal_ball: Sprite2D = get_node("./NormalBall")
@onready var bounce_animations: AnimatedSprite2D = get_node("./BounceBall")

const BOOST: float = 5
const ACCELERATION: float = 1

func _physics_process(delta: float) -> void: 
	if(Input.is_action_just_pressed("shoot") 
	and !Globals.is_game_active):
		Globals.is_game_active = true
		set_starting_velocity()
	
	if(is_main_ball):
		normal_ball.modulate = Color('000000')
	
	collision_info = move_and_collide(velocity * speed * delta)
	Globals.ball_position = position
	
	if(collision_info):
		var collider: Variant = collision_info.get_collider()
		bounce(collider)
		if(speed <= 20):
			speed += ACCELERATION

func set_starting_velocity() -> void:
	
	if(randi() % 2 == 0):
		velocity.x = randf_range(0.6,1.0)
	else:
		velocity.x = randf_range(-0.6,-1.0)
	
	velocity.y = -1
	speed = start_speed
	velocity *= speed
	damage = 1
	Globals.ball_damage = damage

func bounce(collider: Variant) -> void:
	if(collider is Player):
		velocity = pong_bounce(collider)
		bounce_sprite("top-bot")
		return
	else:
		if(collider is Brick): 
			var brick: Brick = collider
			brick.hit(damage)
			velocity = velocity.bounce(collision_info.get_normal())
			bounce_sprite("bot-top")
			return
		if(velocity.x >= 1 and velocity.y < velocity.x):
			bounce_sprite("right-left")
		if(velocity.x <= -1 and velocity.y < velocity.x):
			bounce_sprite("left-right")
			
		bounce_sprite("bot-top")
			
		velocity = velocity.bounce(collision_info.get_normal())

func pong_bounce(collider: Variant) -> Vector2:
	var distance: float = Globals.ball_position.x - collider.position.x
	var new_bounce: Vector2 = Vector2.ZERO
	const MAX_BOUNCE_RANGE: float = 0.8
	
	if velocity.y > 0:
		new_bounce.y = -1
	else:
		new_bounce.y = 1
	new_bounce.x = (distance / (Globals.PLAYER_WIDTH/ 2)) * MAX_BOUNCE_RANGE
	
	return new_bounce.normalized() * speed

func bounce_sprite(side: String) -> void:
	bounce_animations.stop()
	normal_ball.visible = false
	bounce_animations.visible = true
	bounce_animations.play(side)

func _on_bounce_ball_animation_finished() -> void:
	bounce_animations.visible = false
	normal_ball.visible = true
