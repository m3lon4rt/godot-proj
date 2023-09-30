class_name WalkerVariantHitState
extends WalkerState

@export var actor: WalkerVariant
@export var animator: AnimatedSprite2D
@export var emitter: CPUParticles2D
@export var hit_stun = 50

var hit_stun_counter = hit_stun

signal recovered
signal hit

func _ready():
	hit_stun_counter = hit_stun
	set_physics_process(false)

func _enter_state() -> void:
	print("Hit")
	hit_stun_counter = hit_stun
	
	actor.get_node("Player_Detect").text = "@"
	actor.get_node("Hit_Emitter").emitting = true
	actor.physic_hp_count -= 5
	actor.magic_hp_count -= 5
	
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta):
	if hit_stun_counter > 0:
		hit_stun_counter -= 1
	
	if actor.get_node("Area2D").has_overlapping_areas() and hit_stun_counter <= hit_stun-5:
		hit.emit()
	
	if hit_stun_counter == 0:
		recovered.emit()
