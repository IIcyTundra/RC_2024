extends AZState

@export
var idle_state: AZState
@export
var fall_state: AZState

func enter() -> void:
	super()



func process_physics(delta: float) -> AZState:
	#parent.velocity.y += gravity * delta
	parent.followPlayer()
	parent.move_and_slide()
	#print("chase state")
	#print("x: "+str(parent.position.x)+" | y: "+str(parent.position.y))
	if not parent.is_on_floor():
		return fall_state
	if parent.isInAttackRange():
		return idle_state
	return null
