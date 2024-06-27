extends CharacterBody2D

var start_speed: float = 15
var speed: float = start_speed
var damage: int

const BOOST: float = 5
const ACCELERATION: float = 1

func _ready() -> void:
	if(Input.is_action_just_pressed("shoot")):
		set_starting_velocity()

func _physics_process(delta: float) -> void:
	bounce(delta)

func set_starting_velocity() -> void:
	
	if(randi() % 2 == 0):
		velocity.x = 1
	else:
		velocity.x = -1
	
	velocity.y = -1
	speed = start_speed
	velocity *= speed

func bounce(delta: float) -> void:
	var collision_info : KinematicCollision2D = move_and_collide(velocity * speed * delta)
	
	Globals.ball_position = position
	
	if(collision_info):
		var collider: CharacterBody2D = collision_info.get_collider()
		if('IS_PADDLE' in collider):
			if(speed <= 30):
				speed += ACCELERATION
			velocity = pong_bounce(collider)
		else:
			velocity = velocity.bounce(collision_info.get_normal())

func pong_bounce(collider: CharacterBody2D) -> Vector2:
	var distance: Vector2 = Vector2(0,Globals.ball_position.y - collider.position.y)
	var new_bounce: Vector2 = Vector2.ZERO
	const MAX_BOUNCE_RANGE: float = 0.6
	
	if velocity.x > 0:
		new_bounce.x = -1
	else:
		new_bounce.x = 1
	
	new_bounce.y = (distance / (collider.get_node("Player/CollisionShape2D").shape.width / 2)) * MAX_BOUNCE_RANGE
	return new_bounce.normalized() * speed
