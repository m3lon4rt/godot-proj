extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var wall_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")*0.20
var is_wall_sliding = false
@export var jumps = 0
@export var wall_jumps = 0
@export var screen_shake = 1*0.15
var on_wall = false
var on_ground = false

var jump = jumps
var wall_jump = wall_jumps

func _physics_process(delta):
	
	if is_on_floor():
		if !on_ground:
			get_node("Camera2D").trauma = screen_shake
		
		on_ground = true
		jump = jumps
		wall_jump = wall_jumps
	else:
		on_ground = false
	
	# Handle Wall Jump
	wall_jumping(delta)
	
	# Handle Jump.
	jumping(delta)
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func jumping(delta):
	velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up"):
		if is_on_floor() or jump > 0 and !is_wall_sliding:
			jump -= 1
			velocity.y = JUMP_VELOCITY
			get_node("CPUParticles2D").emitting = true

func wall_jumping(delta):
	wall_slide(delta)
	
	if is_wall_sliding and Input.is_action_just_pressed("ui_right") and wall_jump > 0 and !get_node("RayCast2D2").is_colliding():
		wall_jump -= 1
		velocity.y = JUMP_VELOCITY
		get_node("Camera2D").trauma = screen_shake
		get_node("CPUParticles2D").emitting = true
	if is_wall_sliding and Input.is_action_pressed("ui_left") and wall_jump > 0 and !get_node("RayCast2D").is_colliding():
		wall_jump -= 1
		velocity.y = JUMP_VELOCITY
		get_node("Camera2D").trauma = screen_shake
		get_node("CPUParticles2D").emitting = true

func wall_slide(delta):
	wall_check()
	
	if on_wall and !is_on_floor():
		is_wall_sliding = true
	else:
		is_wall_sliding = false
	
	if is_wall_sliding:
		velocity.y += wall_gravity * delta
		velocity.y = min(velocity.y, wall_gravity)
		
		get_node("CPUParticles2D2").emitting = true
	else:
		get_node("CPUParticles2D2").emitting = false

func wall_check():
	if get_node("RayCast2D").is_colliding() or get_node("RayCast2D2").is_colliding():
		on_wall = true
	else:
		on_wall = false
