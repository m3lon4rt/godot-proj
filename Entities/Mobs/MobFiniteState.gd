# Finite State Machine Class that handles state changing
class_name MobFiniteState
extends Node

# Default state (Required)
@export var state: MobState

# When ready, enter default state
func _ready():
	change_state(state)

# Function that handles state switching
func change_state(new_state: MobState):
	if state is MobState:
		state._exit_state()
	new_state._enter_state()
	state = new_state
