extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var animated_sprite = $AnimatedSprite2D
@onready var attack_1_hit_box = $Node/Attack1HitBox

var attacking = false
var attack_counter = 0

var jumping = false
var jump_countdown = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	attack_1_hit_box.set_inactive()

func _physics_process(delta):
	print(attack_1_hit_box.is_monitoring())
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
		velocity.y = JUMP_VELOCITY
	elif jump_countdown > 10:
		if is_on_floor():
			jump_countdown = 0
			jumping = false
			
		
func attack():
	attack_counter += 1
	if attack_counter == 10:
		attack_1_hit_box.set_active()
		attack_1_hit_box.set_position(position)
		print("attack")
	if attack_counter == 40:
		attack_1_hit_box.set_inactive()
		attack_counter = 0
		attacking = false
		
	
	
