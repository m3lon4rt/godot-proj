class_name WalkerVariantDeathState
extends MobState

@export var actor: WalkerVariant
@export var animator: AnimatedSprite2D
@export var death_time = 50 # temporary

var death_time_counter

func _ready():
	death_time_counter = death_time
	
	# Stop physics process when loaded
	set_physics_process(false)

func _enter_state() -> void:
	print("Dead")
	actor.get_node("Player_Detect").text = "X"
	
	actor.target.get_node('Basic_Atk').kills += 1
	
	# Enable physics process when entered
	set_physics_process(true)

func _exit_state() -> void:
	# Stop physics process when on a different state
	set_physics_process(false)

func _physics_process(delta):
	if death_time_counter > 0:
		death_time_counter -= 1
	
	if death_time_counter <= 0:
		actor.queue_free()
