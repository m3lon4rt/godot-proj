class_name WalkerStillState
extends WalkerState

@export var actor: Walker
@export var vision_cast: RayCast2D

func _ready():
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)
	if actor.velocity == Vector2.ZERO:
		actor.velocity.x += randi_range(-1, 1) * actor.ACCELERATION

func _exit_state() -> void:
	set_physics_process(false)
	
func _physics_process(delta):
	pass
