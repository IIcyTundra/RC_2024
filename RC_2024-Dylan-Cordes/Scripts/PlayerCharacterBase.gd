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

var combo = 0
@onready var zoneBuffer: Timer
@onready var rushComboBuffer: Timer
@onready var zoneLength: Timer
@onready var heavyTimer: Timer
#zone check, ignore
var lef = false
var rig = false
#think of this as the buffer looking for button clicks while attack animations are playing
var animStart = false

func gravity(delta):
	if not is_on_floor():
		velocity.y -= gravityNorm * delta 

func _ready():
	
	sloted_abilities.resize(player_stats.ABILITY_SLOT_MAX)
	Input.MOUSE_MODE_HIDDEN
	zoneBuffer = $InitialZoneAttackBuffer
	rushComboBuffer = $RushComboBuffer
	heavyTimer = $heavyTimer
	zoneLength = $zoneLength
	zoneBuffer.set_paused(true)
	rushComboBuffer.set_paused(true)
	zoneLength.set_paused(true)
	heavyTimer.set_paused(true)
	#THIS IS COMMENTED OUT SINCE IT WILL NOT RUN ON MY BUILD, IDK WHY, WILL FIX WHEN PLAYER COMBAT IS COMPLETE
#	sloted_abilities.resize(player_stats.ABILITY_SLOT_MAX)
	#if(player_stats.abilities != null && player_stats.abilities.size() <= player_stats.ABILITY_SLOT_MAX):
		#var i = 0
		#for name in player_stats.abilities:
			#sloted_abilities[i] = load_ability(name)
			#i += 1
	#else:
		#push_error("Ability slots are either NULL, or exceeds the current maximum")
func _process(delta):
	#print(zoneBuffer.time_left)
	if Input.is_action_just_pressed("Light"):
		lef = true
		if animStart != true:
			zoneBuffer.paused = !zoneBuffer.paused
			animStart = true
			print("lftClick")
		elif combo > 0 && combo != 4:
			lef = true
			print("lftBuffer")
		else:
			print("buffereaten")
	if Input.is_action_just_pressed("Heavy"):
		rig = true
		if animStart != true:
			zoneBuffer.paused = !zoneBuffer.paused
			animStart = true
			print("rigClick")
		elif combo > 0:
			rig = true
			print("rgtBuffer")
		else:
			print("bufferEaten")
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
	
	if animStart == false:
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

func zone_attack():
	print("zone start")
	zoneLength.set_paused(false)

func light_attack_start():
	combo += 1
	rushComboBuffer.set_paused(false)
	lef = false
	if(combo <= 4):
		print("light: ",combo)
	else:
		print("Light Not Used")
	

func heavy_attack_start():
	print("heavy start")
	rushComboBuffer.set_paused(true)
	rushComboBuffer.start()
	heavyTimer.set_paused(false)

func dodge():
	pass

func _on_initial_zone_attack_buffer_timeout():
	if((lef and rig == true) and combo < 1):
		zone_attack()
	elif(lef == true):
		light_attack_start()
	elif(rig == true):
		heavy_attack_start()
	lef = false
	rig = false
	zoneBuffer.paused = !zoneBuffer.paused


func _on_rush_combo_buffer_timeout():
	if rig == true:
		heavy_attack_start()
		
	elif lef == true && combo < 4:
		light_attack_start()
	else:
		animStart = false
		lef = false
		rig = false
		print("rush end")
		combo = 0
		rushComboBuffer.set_paused(true)

func _on_zone_length_timeout():
	print("zone attack")
	animStart = false
	combo = 0
	lef = false
	rig = false
	zoneLength.set_paused(true)

func _on_heavy_timer_timeout():
	if combo == 0:
		print("heavy")
	elif combo == 1:
		print("heavy end 1")
	elif combo == 2:
		print("heavy end 2")
	elif combo == 3:
		print("heavy end 3")
	else:
		print("heavy end 4")
	animStart = false
	lef = false
	rig = false
	combo = 0
	rushComboBuffer.set_paused(true)
	heavyTimer.set_paused(true)
