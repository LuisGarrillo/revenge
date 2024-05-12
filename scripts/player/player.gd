extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var animated_sprite = $AnimatedSprite2D
@onready var jump_timer = $Timers/JumpTimer

var attacking = false
var attack_counter = 0

var jumping = false
var jump_countdown = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and not attacking:
		jumping = true
		
	if Input.is_action_just_pressed("attack") and not jumping:
		attacking = true
		
	var direction = Input.get_axis("move_left", "move_right")
	
	if is_on_floor() and not jumping:
		if attacking:
			animated_sprite.play("Attack1")
		elif direction:
			animated_sprite.play("Run")
		else:
			animated_sprite.play("Idle")
	elif jumping and jump_countdown == 0:
		animated_sprite.play("Jump")
		
	if jumping:
		jump()
		
	if attacking:
		attack()
	
	# Handle movement
	if direction and not attacking:
		velocity.x = direction * SPEED
		animated_sprite.flip_h = bool(direction - 1)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	
func jump():
	jump_countdown += 1
	if jump_countdown == 10:
		jumping = false
		jump_countdown = 0
		velocity.y = JUMP_VELOCITY
		
func attack():
	attack_counter += 1
	if attack_counter == 10:
		print("attack")
	if attack_counter == 40:
		attack_counter = 0
		attacking = false
	
	
