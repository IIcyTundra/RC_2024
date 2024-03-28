extends AZState

@export
var fall_state: AZState
@export
var chase_state: AZState
@export
var melee_attack_state: AZState
@export
var idle_state: AZState

@onready
var anim_tree = $"../../MeleeEnemyAni/AnimationTree"
func enter() -> void:
	super()
	parent.velocity.x = 0
	parent.velocity.z = 0
	anim_tree.set("parameters/conditions/isPostureBroken",true)
	#parent.velocity.y = 0
func exit() -> void:
	super.exit()
	anim_tree.set("parameters/conditions/isPostureBroken",false)



func process_physics(delta: float) -> AZState:
	#parent.velocity.y -= gravity * delta
	#parent.move_and_slide()
	parent.regen_SP(0)
	#print("x: "+str(parent.position.x)+" | y: "+str(parent.position.y))
	if parent.postureBroken:
		return null
	else:
		return idle_state
