extends AZState

@export
var idle_state: AZState
@export
var fall_state: AZState
@export
var chase_state: AZState
@export
var posture_broken_state: AZState
@onready
var anim_tree = $"../../MeleeEnemyAni/AnimationTree"
func enter() -> void:
	super.enter()
	anim_tree.set("parameters/conditions/isAttacking",true)

func exit() -> void:
	super.exit()
	anim_tree.set("parameters/conditions/isAttacking",false)

func process_physics(delta: float) -> AZState:
	var playback = anim_tree.get("parameters/playback")
	print("attack state")
	print("playback: " +playback.get_current_node())
	#print("x: "+str(parent.position.x)+" | y: "+str(parent.position.y))
	if not parent.is_on_floor():
		return fall_state
	if parent.postureBroken:
		return posture_broken_state
	if playback.get_current_node() != "attack":
		return idle_state
	return null
