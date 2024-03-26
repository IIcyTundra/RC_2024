extends Button

@onready var click_sound = AudioStreamPlayer.new()

func _ready() -> void:
	click_sound.stream = load("res://Audio/PlayStation 2 - System BIOS PS2 - Sound Effects/Sound Effects/scph10000_00022.wav")
	pressed.connect(func(): click_sound.play())
	add_child(click_sound)
	
func _process(delta):
	pass



