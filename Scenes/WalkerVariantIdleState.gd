class_name WalkerVariantIdleState
extends WalkerState

@export var actor: WalkerVariant
@export var animator: AnimatedSprite2D
@export var vision_cast: RayCast2D

signal saw_player
signal hit

func _ready():
	set_physics_process(false)

func _enter_state() -> void:
	print("Idle")
	actor.get_node("Player_Detect").text = "?"
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta):
	if not vision_cast.is_colliding():
		saw_player.emit()
