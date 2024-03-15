class_name AZState
extends Node

@export
var animation_name: String
@export
var move_speed: float = 300

var gravity: int = ProjectSettings.get_setting("physics/3d/default_gravity")

# Hold a reference to the parent so that it can be controlled by the state
var parent: MeleeEnemy

func enter() -> void:
	pass

func exit() -> void:
	pass

func process_input(event: InputEvent) -> AZState:
	return null

func process_frame(delta: float) -> AZState:
	return null

func process_physics(delta: float) -> AZState:
	return null
