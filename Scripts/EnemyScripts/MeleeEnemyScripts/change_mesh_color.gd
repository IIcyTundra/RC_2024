extends CSGMesh3D

@onready var pillMesh = $CSGMesh3D

var default_color = null
# Called when the node enters the scene tree for the first time.
func _ready():
	make_new_color()
	 # Replace with function body.

func make_new_color():
	var material = pillMesh.get("material/0").duplicate()
	default_color = material.albedo_color
	default_color = Color.PINK
	pillMesh.set("material/0", material)
