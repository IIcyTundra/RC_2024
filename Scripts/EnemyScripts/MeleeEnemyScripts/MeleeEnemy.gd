class_name MeleeEnemy
extends Enemy
@onready
var state_machine = $state_machine

func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	super._ready()
	state_machine.init(self)
	
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	var player = get_tree().get_nodes_in_group("PlayerGroup")[0]
	print("Player Pos:" + str(player.position) + "En Pos:" + str(position))
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
