extends State

@export
var fall_state: State
@export
var chase_state: State

func enter() -> void:
	super()
	parent.velocity.x = 0
	parent.velocity.z = 0
	var mesh: CSGMesh3D = parent.get_child(1)
	
	#parent.velocity.y = 0



func process_physics(delta: float) -> State:
	parent.velocity.y -= gravity * delta
	parent.move_and_slide()
	print("idle state")
	print("x: "+str(parent.position.x)+" | y: "+str(parent.position.y))
	if not parent.is_on_floor():
		return fall_state
	if not parent.isInAttackRange() && parent.is_on_floor():
		return chase_state
	return null
