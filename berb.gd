extends CharacterBody2D

const GRAVETAT : int = 1000
const VELOCITATMAX : int = 600
const FLAPSPEED : int = -500
const POSINI : = Vector2(100,400)
var volant : bool = false
var caient : bool = false



func _ready():
	reset()

func reset():
	caient = false
	volant = false
	position = POSINI
	set_rotation(0)

func _physics_process(delta):
	if volant or caient:
		velocity.y += GRAVETAT * delta
		#terminal velocity
		if velocity.y > VELOCITATMAX:
			velocity.y = VELOCITATMAX
		if volant:
			set_rotation(deg_to_rad(velocity.y * 0.05))
			$AnimatedSprite.play()
		elif caient:
			set_rotation(PI/2)
			$AnimatedSprite.stop()
		move_and_collide(velocity * delta)
	else:
		$AnimatedSprite.stop()
		
func flap():
	velocity.y = FLAPSPEED
