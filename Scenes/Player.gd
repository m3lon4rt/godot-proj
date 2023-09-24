class_name Player
extends CharacterBody2D

# Constants
const SPEED = 75
const MAX_SPEED = 300.0
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
@export var fuel = 0 # 1 - 100 should be fine
@export var screen_shake = 1*0.15

# Jump and Fuel counters
var jump
var wall_jump
var fuel_count

# Executes at start
func _ready():
	# Initialize counters
	jump = jumps
	wall_jump = wall_jumps
	fuel_count = fuel

# executes every physics step
func _physics_process(delta):
	# Debug messages
	# print("fuel: %d" % fuel_count)
	get_node("Label").text = str(fuel_count)
	
	# Stuff to do when on the floor/landing
	if is_on_floor():
		# Screenshake when landing
		if !on_ground:
			get_node("Camera2D").trauma = screen_shake
		
		# to check if player just landed
		on_ground = true
		
		# Reset jump acounters
		jump = jumps
		wall_jump = wall_jumps
		
		# Replenish fuel
		if fuel_count < fuel:
			fuel_count += 1
	else:
		on_ground = false
	
	# handles Flying
	flying(delta)
	
	# Handles Wall Jump
	wall_jumping(delta)
	
	# Handles Jump.
	jumping(delta)
	
	# Get the input direction and handle the movement.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x += direction * SPEED
	else:
		velocity.x += 0
	
	# Slow down horizontal movement (friction)
	if velocity.x > 10:
		velocity.x -= 20
	elif velocity.x < -10:
		velocity.x += 20
	else:
		velocity.x = 0
	
	# Limit speed of horizontal flight
	if velocity.x < -MAX_SPEED:
		velocity.x = -MAX_SPEED
	elif velocity.x > MAX_SPEED:
		velocity.x = MAX_SPEED
	
	#physics
	move_and_slide()

# Function that handles flying
func flying(_delta):
	if Input.is_action_pressed("activate_flight") and fuel_count > 0:
		flight_on = true
		# Consume Fuel
		fuel_count -= 1 
		
		# Slow down previous vertical movement (friction)
		if velocity.y > 10:
			velocity.y -= 20
		elif velocity.y < -10:
			velocity.y += 0
		else:
			velocity.y = 0
			
		# Limit speed of vertical flight
		if velocity.y < -MAX_SPEED:
			velocity.y = -MAX_SPEED
		elif velocity.y > MAX_SPEED - 100: # Slower speed when flying down so it feels natural
			velocity.y = MAX_SPEED - 100
	
	if Input.is_action_just_released("activate_flight") or fuel_count == 0:
		flight_on = false
	
	if flight_on:
		var vert_dir = Input.get_axis("ui_up","ui_down")
		# Get the input direction and handle the movement.
		if vert_dir:
			velocity.y += vert_dir * SPEED
		else:
			velocity.y += 0
		
		# Particle emitter on
		get_node("Emitters/Flight_Emitter").emitting = true
	else:
		# Particle emitter off
		get_node("Emitters/Flight_Emitter").emitting = false

# Function that handles jumping
func jumping(delta):
	# Gravity
	velocity.y += gravity * delta
	
	# Jump
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up"):
		if is_on_floor() and jump > 0 or jump > 0:
			if !flight_on:
				jump -= 1
				velocity.y = JUMP_VELOCITY
				# Particle Emitter
				get_node("Emitters/Jump_Emitter").emitting = true

# Function that handles wall jumping
func wall_jumping(delta):
	# Handles wall slide
	wall_slide(delta)
	
	# Checks which direction the wall is and if you're wall sliding then does a wall jump if you move in the opposite direction
	if is_wall_sliding and Input.is_action_just_pressed("ui_right") and wall_jump > 0 and !get_node("RayCasts/Right_Collision").is_colliding():
		wall_jump -= 1
		velocity.y = JUMP_VELOCITY
		# Screenshake and Particle Emitter
		get_node("Camera2D").trauma = screen_shake
		get_node("Emitters/Jump_Emitter").emitting = true
	if is_wall_sliding and Input.is_action_just_pressed("ui_left") and wall_jump > 0 and !get_node("RayCasts/Left_Collision").is_colliding():
		wall_jump -= 1
		velocity.y = JUMP_VELOCITY
		# Screenshake and Particle emitter		
		get_node("Camera2D").trauma = screen_shake
		get_node("Emitters/Jump_Emitter").emitting = true

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
		
		# Replenish fuel
		if fuel_count < fuel:
			fuel_count += 1
		
		# Particle emitter on
		get_node("Emitters/Wall_Slide_Emitter").emitting = true
	else:
		# Particle emitter off
		get_node("Emitters/Wall_Slide_Emitter").emitting = false

# Custom wall checking function bec "is_on_wall()" doesn't work in this use case
func wall_check():
	if get_node("RayCasts/Left_Collision").is_colliding() or get_node("RayCasts/Right_Collision").is_colliding():
		on_wall = true
	else:
		on_wall = false
