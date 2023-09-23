class_name Walker
extends CharacterBody2D


@export var MAX_SPEED = 40.0
@export var ACCELERATION = 50.0
@onready var ray_cast_2d = $RayCast2D
@export var target = Player

@export var physic_hp = 100
@export var magic_hp = 100

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
	
	print("raycast direction: %d" % ray_cast_2d.target_position.x)
	
	print("velocity.x: %d" % velocity.x)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	ray_cast_2d.target_position = target.global_position - ray_cast_2d.global_position + Vector2(16,16)
	# added the last bit to compensate for the player's origin being at its upper left
	
	var player_direction = ray_cast_2d.target_position.x
	if player_direction > 0:
		velocity.x += ACCELERATION
	elif player_direction < 0:
		velocity.x -= ACCELERATION
	else:
		velocity.x = 0
		
	if velocity.x < -MAX_SPEED:
		velocity.x = -MAX_SPEED
	elif velocity.x > MAX_SPEED:
		velocity.x = MAX_SPEED
	
	move_and_slide()
