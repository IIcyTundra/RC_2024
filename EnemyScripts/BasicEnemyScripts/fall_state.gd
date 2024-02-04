extends State

@export
var idle_state: State
@export
var chase_state: State

func enter() -> void:
	super()



func process_physics(delta: float) -> State:
	parent.velocity.y -= gravity * delta
	print("fall state")
	print("x: "+str(parent.position.x)+" | y: "+str(parent.position.y))
	parent.move_and_slide()
	if parent.is_on_floor():
		return idle_state
	return null
