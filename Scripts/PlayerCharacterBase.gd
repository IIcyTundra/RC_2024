extends Entity
const ABILITY_SLOT_MAX : int = 3
@export var abilities = {} #key = sting, value = scene
var sloted_abilities = []


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	sloted_abilities.resize(ABILITY_SLOT_MAX)
	if(abilities != null && abilities.size() <= ABILITY_SLOT_MAX):
		var i = 0
		for key in abilities:
			sloted_abilities[i] = load_ability(key)
			i += 1
	else:
		push_error("Ability slots are either NULL, or exceeds the current maximum")
		
	
func _process(delta):
	if Input.is_action_just_pressed("ability_1"):
		if sloted_abilities[0] != null:
			sloted_abilities[0].execute()
	if Input.is_action_just_pressed("ability_2"):
		if sloted_abilities[1] != null:
			sloted_abilities[1].execute()
	if Input.is_action_just_pressed("ability_3"):
		if sloted_abilities[2] != null:
			sloted_abilities[2].execute()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta 

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()
