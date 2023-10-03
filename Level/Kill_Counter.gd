extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.text = "Kills: %d" % $%Player.get_node('Basic_Atk').kills
