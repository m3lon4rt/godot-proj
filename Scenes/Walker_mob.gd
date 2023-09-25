class_name Walker
extends CharacterBody2D


@export var MAX_SPEED = 40.0
@export var ACCELERATION = 5.0
@export var JUMP_VELOCITY = 350.0
@export var target = Player

@export var physic_hp = 100
@export var magic_hp = 100

@onready var track_player_cast = $TrackPlayer
@onready var obstacle_cast = $JumpObstacleCheck
@onready var reach_cast = $JumpReachCheck

var physic_hp_count
var magic_hp_count

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	physic_hp_count = physic_hp
	magic_hp_count = magic_hp

func _physics_process(delta):
	# Debug for HP values)
	get_node("PhysicHP").text = str(physic_hp)
	get_node("MagicHP").text = str(magic_hp)
	
	# Debug for player detection and tracking
	if track_player_cast.is_colliding():
		get_node("PlayerDetect").text = str("?")
	else:
		get_node("PlayerDetect").text = str("!")
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	track_player()
	
	check_for_jump()
	
	move_and_slide()

func track_player():
	track_player_cast.target_position = target.global_position - track_player_cast.global_position + Vector2(16,16)
	# added the last bit to compensate for the player's origin being at its upper left
	
	# obtain player position relative to walker and move walker towards player
	track_player_cast.add_exception(target)
	var player_direction = track_player_cast.target_position.x
	
	# set Walker movement based on player position; stop when player is obstructed
	if !track_player_cast.is_colliding():
		if player_direction > 0:
			velocity.x += ACCELERATION
		elif player_direction < 0:
			velocity.x -= ACCELERATION
	else:
		if velocity.x > 0:
			velocity.x -= ACCELERATION
		elif velocity.x < 0:
			velocity.x += ACCELERATION
		else:
			velocity.x = 0
		
	
	# limit horizontal speed
	if velocity.x < -MAX_SPEED:
		velocity.x = -MAX_SPEED
	elif velocity.x > MAX_SPEED:
		velocity.x = MAX_SPEED
		
# controls raycasts that checks whether Walker can jump over an obstacle
func check_for_jump():
	var direction = 0
	
	if velocity.x > 0:
		direction = 1
	elif velocity.x < 0:
		direction = -1

	obstacle_cast.add_exception(target)
	reach_cast.add_exception(target)
	
	obstacle_cast.target_position = Vector2(velocity.x/2 + 17 * direction, 0)
	reach_cast.target_position = Vector2(velocity.x/2 + 17 * direction, -30)
	
	if obstacle_cast.is_colliding() and is_on_floor() and !reach_cast.is_colliding():
		velocity.y -= JUMP_VELOCITY
