extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	var mob = preload("res://Entities/Mobs/Walker_mob_variant.tscn").instantiate()
	mob.set_position(self.global_position)
	get_parent().add_child(mob)
