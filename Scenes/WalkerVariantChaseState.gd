class_name WalkerVariantChaseState
extends WalkerState

@export var actor: WalkerVariant
@export var animator: AnimatedSprite2D
@export var vision_cast: RayCast2D

signal lost_player
signal hit

func _ready():
	set_physics_process(false)

func _enter_state() -> void:
	print("Moving")
	actor.get_node("Player_Detect").text = "!"
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta):
	vision_cast.add_exception(actor.target)
	var target_direction = vision_cast.target_position.x
	
	# set Walker movement based on player position; stop when player is obstructed
	if !vision_cast.is_colliding():
		if target_direction > 0:
			actor.velocity.x += actor.acceleration
		elif target_direction < 0:
			actor.velocity.x -= actor.acceleration
	else:
		if actor.velocity.x > 0:
			actor.velocity.x -= actor.acceleration
		elif actor.velocity.x < 0:
			actor.velocity.x += actor.acceleration
		else:
			actor.velocity.x = 0
	
	# limit horizontal speed
	if actor.velocity.x < -actor.max_speed:
		actor.velocity.x = -actor.max_speed
	elif actor.velocity.x > actor.max_speed:
		actor.velocity.x = actor.max_speed
	
	actor.move_and_slide()
	
	if vision_cast.is_colliding():
		lost_player.emit()
