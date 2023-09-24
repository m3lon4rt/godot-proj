extends Area2D

var atk_decay = 5
var victims = 0
var hits = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Basic_Atk_Hitbox").disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(get_global_mouse_position())
	atk_decay -= 1
	
	if Input.is_action_just_pressed("basic_attack"):
		atk_decay = 3
		self.modulate = Color(1, 1, 1)
		get_node("Basic_Atk_Hitbox").disabled = false
	else:
		if atk_decay == 0:
			victims = 0
			self.modulate = Color().hex(002211)
			get_node("Basic_Atk_Hitbox").disabled = true
	
	if self.has_overlapping_bodies() and get_node("Basic_Atk_Hitbox").disabled == false:
		hits += 1 * self.get_overlapping_bodies().size()
