class_name Walker
extends CharacterBody2D


const SPEED = 300.0
@export var MAX_SPEED = 40.0
@export var ACCELERATION = 50.0
@onready var ray_cast_2d = $RayCast2D

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
	# Debug for HP values
	print("physic_hp: %d" % physic_hp_count)
	get_node("PhysicHP").text = str(physic_hp)
	
	print("magic_hp: %d" % magic_hp_count)
	get_node("MagicHP").text = str(magic_hp)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	ray_cast_2d.target_position = get_local_mouse_position()
	
	move_and_slide()
