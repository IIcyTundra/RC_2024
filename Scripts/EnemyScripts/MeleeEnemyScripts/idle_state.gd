extends AZState

@export
var fall_state: AZState
@export
var chase_state: AZState
@export
var melee_attack_state: AZState
@onready
var anim_tree = $"../../MeleeEnemyAni/AnimationTree"
func enter() -> void:
	super()
	parent.velocity.x = 0
	parent.velocity.z = 0
	anim_tree.set("parameters/conditions/isIdle",true)
	#parent.velocity.y = 0
func exit() -> void:
	super.exit()
	anim_tree.set("parameters/conditions/isIdle",false)



func process_physics(delta: float) -> AZState:
	#parent.velocity.y -= gravity * delta
	parent.move_and_slide()
	print("idle state")
	#print("x: "+str(parent.position.x)+" | y: "+str(parent.position.y))
	if not parent.is_on_floor():
		return fall_state
	if not parent.isInAttackRange() && parent.is_on_floor():
		return chase_state
	if parent.isInAttackRange():
		return melee_attack_state
	return null
