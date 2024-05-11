extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var animated_sprite = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	
	# Set animations
	if direction:
		animated_sprite.play("Run")
	else:
		animated_sprite.play("Idle")
	
	
	# Handle movement
	if direction:
		velocity.x = direction * SPEED
		animated_sprite.flip_h = bool(direction - 1)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	print(position.x)

	move_and_slide()
