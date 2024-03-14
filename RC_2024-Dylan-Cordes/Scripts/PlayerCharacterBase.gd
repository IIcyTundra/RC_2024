extends Entity
class_name PlayerControlsBase
@export var player_stats : Player_Base_Stats
var sloted_abilities = []

@onready var camera = $"hitbox & camera rig/Camera3D"
@onready var cameraRig = $"hitbox & camera rig"
@onready var cursor = $cursor
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravityNorm = ProjectSettings.get_setting("physics/3d/default_gravity")

var dashNum = 2
var medRoll = 15

const initialAttackBuffer = 300
const lightAttackTime = 1000
var lftClickTime = 0
var rgtClickTime = 0
enum PlayerState{
	Idle,
	Light,
	Heavy,
	Zone
}
var lightCounter = 1;
var Buffer = false;
var currentAttack = PlayerState.Idle

func gravity(delta):
	if not is_on_floor():
		velocity.y -= gravityNorm * delta 

func _ready():
	sloted_abilities.resize(player_stats.ABILITY_SLOT_MAX)
	Input.MOUSE_MODE_HIDDEN
	#THIS IS COMMENTED OUT SINCE IT WILL NOT RUN ON MY BUILD, IDK WHY, WILL FIX WHEN PLAYER COMBAT IS COMPLETE
#	sloted_abilities.resize(player_stats.ABILITY_SLOT_MAX)
	#if(player_stats.abilities != null && player_stats.abilities.size() <= player_stats.ABILITY_SLOT_MAX):
		#var i = 0
		#for name in player_stats.abilities:
			#sloted_abilities[i] = load_ability(name)
			#i += 1
	#else:
		#push_error("Ability slots are either NULL, or exceeds the current maximum")
func _process(delta: float) -> void:
	var current_time = Time.get_unix_time_from_system() *1000
	
	
	if Input.is_action_just_pressed("Light"):
		if currentAttack == PlayerState.Light:
			lightCounter += 1
			Buffer = true
			if(lightCounter > 4):
				lightCounter = 1
			print("chain attack - ", lightCounter)
		elif currentAttack == PlayerState.Idle:
			currentAttack = PlayerState.Light
			lftClickTime = current_time
			lightCounter = 1
			print("light 1")
		elif currentAttack != PlayerState.Idle:
			pass
			
	if Input.is_action_just_pressed("Heavy"):
		if currentAttack == PlayerState.Idle:
			pass
		
	
	if(current_HP <= 0):
		player_death()
	if Input.is_action_just_pressed("ability_1"):
		if sloted_abilities[0] != null:
			sloted_abilities[0].execute()
	if Input.is_action_just_pressed("ability_2"):
		if sloted_abilities[1] != null:
			sloted_abilities[1].execute()
	if Input.is_action_just_pressed("ability_3"):
		if sloted_abilities[2] != null:
			sloted_abilities[2].execute()
	if Input.is_action_just_pressed("debug_test"):
		remove_ability(sloted_abilities[0])
		
		
func _physics_process(delta):
	look_at_cursor()
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	
	var input_dir = Input.get_vector("left", "right", "up", "down")
	input_dir = input_dir.normalized() # Normalize the input direction vector
	if input_dir.length() > 0:
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized() * current_speed
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
		#Dodge(big burst of velocity) towards direction player is moving
		#TODO dodge is supposed to have slight immunity for spot-dodging, implementing later
		if Input.is_action_just_pressed("dodge") and dashNum >= 1 :
			#dashNum = dashNum - 1 
			#TODO ^^^^ this commented line to come back with movement rework AKA when dodging becomes complete
			
			velocity.x = direction.x * current_speed * medRoll
			velocity.z = direction.z * current_speed * medRoll
	else:
		pass
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	
	move_and_slide()


func look_at_cursor():
	#horizontal plane, no looking up or down
	var player_pos = global_transform.origin
	var dropPlane = Plane(Vector3(0,1,0), player_pos.y)
	
	#ray blast from camera, player will look at it
	var ray_length = 500
	var mousePos = get_viewport().get_mouse_position()
	var rayOrig = camera.project_ray_origin(mousePos)
	var rayEnd = rayOrig + camera.project_ray_normal(mousePos) * ray_length
	var cursor_Pos = dropPlane.intersects_ray(rayOrig, rayEnd)
	#TODO: The cursor is off from the mouse, but the player looks at the mouse consistently rather than the cursor
	#The cursor is mainly for visual feedback for the ray currently, will remove later
	if(cursor_Pos != null):
		cursor.global_transform.origin = cursor_Pos + Vector3(0,1,0)
		#the player mesh looks at it
		$MeshInstance3D2.look_at(cursor_Pos, Vector3.UP)

func player_death():
	print("dead")

func light_attack():
	pass
