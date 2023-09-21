extends CharacterBody2D

# Constants
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# Pseudo friction during wall slide
var wall_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")*0.20
var is_wall_sliding = false
var on_wall = false
var on_ground = false
var flight_on = false

# Exported variables can be assigned values from the Inspector >>>
@export var jumps = 0 # num of jumps allowed
@export var wall_jumps = 0 # num of wall jumps allowed
@export var screen_shake = 1*0.15

# Jump counters
var jump = jumps
var wall_jump = wall_jumps

# executes every physics step
func _physics_process(delta):
	print(flight_on)
	# Stuff to do when on the floor/landing
	if is_on_floor():
		if !on_ground:
			# Screenshake
			get_node("Camera2D").trauma = screen_shake
		
		on_ground = true
		#reset jump counters
		jump = jumps
		wall_jump = wall_jumps
	else:
		on_ground = false
	
	# handles Flying
	flying(delta)
	
	# Handles Wall Jump
	wall_jumping(delta)
	
	# Handles Jump.
	jumping(delta)
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	#physics
	move_and_slide()

# Function that handles flying
func flying(delta):
	if Input.is_action_pressed("activate_flight"):
		flight_on = true
		wall_gravity = 0
		gravity = 0
		
		velocity.x = 0
		velocity.y = 0
	
	if Input.is_action_just_released("activate_flight"):
		flight_on = false
		gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
		wall_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")*0.20
	
	if flight_on:
		var vert_dir = Input.get_axis("ui_up","ui_down")
		if vert_dir:
			velocity.y = vert_dir * SPEED
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED)
			
		get_node("CPUParticles2D3").emitting = true
	else:
		get_node("CPUParticles2D3").emitting = false

# Function that handles jumping
func jumping(delta):
	# Gravity
	velocity.y += gravity * delta
	
	# Jump
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up"):
		if is_on_floor() and jump > 0 or jump > 0 and !is_wall_sliding:
			if !flight_on:
				jump -= 1
				velocity.y = JUMP_VELOCITY
				# Particle Emitter
				get_node("CPUParticles2D").emitting = true

# Function that handles wall jumping
func wall_jumping(delta):
	# Handles wall slide
	wall_slide(delta)
	
	# Checks which direction the wall is and if you're wall sliding then does a wall jump if you move in the opposite direction
	if is_wall_sliding and Input.is_action_just_pressed("ui_right") and wall_jump > 0 and !get_node("RayCast2D2").is_colliding():
		wall_jump -= 1
		velocity.y = JUMP_VELOCITY
		# Screenshake and Particle Emitter
		get_node("Camera2D").trauma = screen_shake
		get_node("CPUParticles2D").emitting = true
	if is_wall_sliding and Input.is_action_pressed("ui_left") and wall_jump > 0 and !get_node("RayCast2D").is_colliding():
		wall_jump -= 1
		velocity.y = JUMP_VELOCITY
		# Screenshake and Particle emitter		
		get_node("Camera2D").trauma = screen_shake
		get_node("CPUParticles2D").emitting = true

# Function that handles wall sliding
func wall_slide(delta):
	# Checks if player is next to a wall
	wall_check()
	
	if on_wall and !is_on_floor() and !flight_on:
		is_wall_sliding = true
	else:
		is_wall_sliding = false
	
	# Replace gravity with pseudo friction (Lesser gravity)
	if is_wall_sliding:
		velocity.y += wall_gravity * delta
		velocity.y = min(velocity.y, wall_gravity)
		
		# Particle emitter on
		get_node("CPUParticles2D2").emitting = true
	else:
		# Particle emitter off
		get_node("CPUParticles2D2").emitting = false

# Custom wall checking function bec "is_on_wall()" doesn't work in this use case
func wall_check():
	if get_node("RayCast2D").is_colliding() or get_node("RayCast2D2").is_colliding():
		on_wall = true
	else:
		on_wall = false
