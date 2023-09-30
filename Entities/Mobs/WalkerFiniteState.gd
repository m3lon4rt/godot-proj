class_name WalkerFiniteState
extends Node

@export var state: WalkerState

func _ready():
	change_state(state)
	
func change_state(new_state: WalkerState):
	if state is WalkerState:
		state._exit_state()
	new_state._enter_state()
	state = new_state
