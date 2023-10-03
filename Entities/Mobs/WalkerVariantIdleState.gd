class_name WalkerVariantIdleState
extends MobState

@export var actor: WalkerVariant
@export var animator: AnimatedSprite2D
@export var vision_cast: RayCast2D

# Signals for state switching
signal saw_player
signal hit
signal dead

func _ready():
	# Stop physics process when loaded
	set_physics_process(false)

func _enter_state() -> void:
	print("Idle")
	actor.get_node("Player_Detect").text = "?"
	
	# Enable physics process when entered
	set_physics_process(true)

func _exit_state() -> void:
	# Stop physics process when on a different state
	set_physics_process(false)

func _physics_process(delta):
	# Conditions for switching states
	if actor.magic_hp_count <= 0 || actor.physic_hp_count <= 0:
		dead.emit()
	
	if actor.get_node("Area2D").has_overlapping_areas():
		hit.emit()
	
	if not vision_cast.is_colliding():
		saw_player.emit()
