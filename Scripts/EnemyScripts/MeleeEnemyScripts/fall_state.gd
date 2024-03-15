extends AZState

@export
var idle_state: AZState
@export
var chase_state: AZState

func enter() -> void:
	super()



func process_physics(delta: float) -> AZState:
	parent.velocity.y -= gravity * delta
	#print("fall state")
	#print("x: "+str(parent.position.x)+" | y: "+str(parent.position.y))
	parent.move_and_slide()
	if parent.is_on_floor():
		return idle_state
	return null
