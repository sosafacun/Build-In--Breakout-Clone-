extends CharacterBody2D

var start_speed: float = 15
@export var speed: float
var damage: int
var collision_info : KinematicCollision2D

@onready var normal_ball: Sprite2D = get_node("./NormalBall")
@onready var bounce_animations: AnimatedSprite2D = get_node("./BounceBall")

const BOOST: float = 5
const ACCELERATION: float = 1

func _physics_process(delta: float) -> void: 
	if(Input.is_action_just_pressed("shoot")):
		set_starting_velocity()
	
	collision_info = move_and_collide(velocity * speed * delta)
	Globals.ball_position = position
	
	if(collision_info):
		var collider: Variant = collision_info.get_collider()
		bounce(collider)
		if(speed <= 30):
			speed += ACCELERATION

func set_starting_velocity() -> void:
	
	if(randi() % 2 == 0):
		velocity.x = 1
	else:
		velocity.x = -1
	
	velocity.y = -1
	speed = start_speed
	velocity *= speed

func bounce(collider: Variant) -> void:
	if('IS_PADDLE' in collider):
		velocity = pong_bounce(collider)
	else:
		velocity = velocity.bounce(collision_info.get_normal())
	
	if (velocity.y >= -1):
		bounce_sprite("bot-top")
	if(velocity.y <= 1):
		bounce_sprite("top-bot")
	if(velocity.x >= -1):
		bounce_sprite("left-right")
	if(velocity.x <= 1):
		bounce_sprite("right-left")

func pong_bounce(collider: Variant) -> Vector2:
	var distance: Vector2 = Vector2.ZERO
	distance.y = Globals.ball_position.y - collider.position.y
	var new_bounce: Vector2 = Vector2.ZERO
	const MAX_BOUNCE_RANGE: float = 0.6
	
	if velocity.x > 0:
		new_bounce.x = -1
	else:
		new_bounce.x = 1
	
	new_bounce.y = (distance / (collider.shape.height/ 2)) * MAX_BOUNCE_RANGE
	return new_bounce.normalized()

func bounce_sprite(side: String) -> void:
		normal_ball.visible = false
		bounce_animations.visible = true
		bounce_animations.play(side)

func _on_bounce_ball_animation_finished() -> void:
	bounce_animations.visible = false
	normal_ball.visible = true
