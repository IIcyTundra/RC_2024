extends AZState

@export
var idle_state: AZState
@export
var chase_state: AZState
@export
var melee_attack_state: AZState
@onready
var anim_tree = $"../../MeleeEnemyAni/AnimationTree"
func enter() -> void:
	super()
	anim_tree.set("parameters/conditions/isFalling",true)
	
func exit() -> void:
	super.exit()
	anim_tree.set("parameters/conditions/isFalling",false)
	



func process_physics(delta: float) -> AZState:
	parent.velocity.y -= gravity * delta
	#print("fall state")
	#print("x: "+str(parent.position.x)+" | y: "+str(parent.position.y))
	parent.move_and_slide()
	if parent.is_on_floor():
		return idle_state
	return null
