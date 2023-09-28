class_name WalkerVariantHitState
extends WalkerState

@export var actor: WalkerVariant
@export var animator: AnimatedSprite2D
@export var emitter: CPUParticles2D
@export var hit_stun = 0

signal recovered

func _ready():
	set_physics_process(false)

func _enter_state() -> void:
	print("Idle")
	actor.get_node("Player_Detect").text = "?"
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta):
	recovered.emit()
