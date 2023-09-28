class_name WalkerVariant
extends CharacterBody2D

@export var max_speed = 80.0
@export var acceleration = 50.0
@export var jump_velocity = 350.0
@export var physic_hp = 100
@export var magic_hp = 100

@onready var target = $%Player
@onready var state_machine = $StateMachine as WalkerFiniteState
@onready var idle_state = $StateMachine/Idle as WalkerVariantIdleState
@onready var chase_state = $StateMachine/Chase as WalkerVariantChaseState

var physic_hp_count
var magic_hp_count

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	physic_hp_count = physic_hp
	magic_hp_count = magic_hp
	
	idle_state.saw_player.connect(state_machine.change_state.bind(chase_state))
	chase_state.lost_player.connect(state_machine.change_state.bind(idle_state))

func _physics_process(delta):
	$PHP.text = str(physic_hp_count)
	$MHP.text = str(magic_hp_count)
	
	$Player_Track_Cast.target_position = target.global_position - self.global_position
	
	if not is_on_floor():
		velocity.y += gravity * delta
		move_and_slide()
