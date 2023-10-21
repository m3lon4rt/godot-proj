extends Area2D

# I had to add a minute delay so the system registers any collisions
var atk_decay = 0
# Number of enteties hit in one attack
var victims = 0
# Total Hit counter (Could be useful for combos and whatnot, but for now it's just here)
var hits = 0
# Kill counter
var kills = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Basic_Atk_Hitbox").disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Point towards mouse
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("basic_attack"):
		# Delay duration
		atk_decay = 3
		# Change color
		self.modulate = Color(1, 1, 1)
		# Turn on the hitbox
		get_node("Basic_Atk_Hitbox").disabled = false
	else:
		if atk_decay > 0:
			# Decrements decay by 1 overtime
			atk_decay -= 1
		if atk_decay == 0:
			# Reset victim counter
			victims = 0
			# Change color
			self.modulate = Color().hex(002211)
			# Turn off the hitbox
			get_node("Basic_Atk_Hitbox").disabled = true
	
	# Function that checks if any Entities are within the hitbox during the attack
	if self.has_overlapping_bodies() and get_node("Basic_Atk_Hitbox").disabled == false:
		hits += 1 * self.get_overlapping_bodies().size()
		
		get_parent().get_node("Camera2D").trauma = get_parent().screen_shake
