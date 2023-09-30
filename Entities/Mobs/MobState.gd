# State superclass that all mob states inherit from
class_name MobState
extends Node

signal state_finished

func _enter_state() -> void:
	pass
	
func _exit_state() -> void:
	pass
