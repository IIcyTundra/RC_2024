# This class scans the scene to and connects signals from UI elements to audio stream playrs it creates
# This is easy and efficient, unlike replacing every UI element and creating dozens of AudioStreamPlayer nodes

extends Node

@export var root_path : NodePath

# create audio player instances
@onready var sounds = {
	&"Hover" : AudioStreamPlayer.new(),
	&"Pressed" : AudioStreamPlayer.new(),
	&"Cancel" : AudioStreamPlayer.new(),
	&"Message" : AudioStreamPlayer.new(),
	&"Accept" : AudioStreamPlayer.new(),
	}


func _ready() -> void:
	assert(root_path != null, "Empty root path for UI Sounds!")

	# set up audio stream players and load sound files
	for i in sounds.keys():
		sounds[i].stream = load("res://Audio/UISFX/" + str(i) + ".wav")
		# assign output mixer bus
		sounds[i].bus = &"UI"
		# add them to the scene tree
		add_child(sounds[i])

	# connect signals to the method that plays the sounds
	install_sounds(get_node(root_path))

func _unhandled_key_input(event):
	if(root_path.get_as_property_path() == "res://Scenes/main_menu.tscn"):
		if event.is_pressed():
			ui_sfx_play.bind(&"Pressed")

func install_sounds(node: Node) -> void:
	for i in node.get_children():
		if i is Button:
			i.mouse_entered.connect( ui_sfx_play.bind(&"Hover") )
			i.pressed.connect( ui_sfx_play.bind(&"Pressed") )
		elif i is LineEdit:
			i.mouse_entered.connect( ui_sfx_play.bind(&"Hover") )
			i.text_submitted.connect( ui_sfx_play.bind(&"Accept").unbind(1) )
			i.text_change_rejected.connect( ui_sfx_play.bind(&"Cancel").unbind(1) )
			i.text_changed.connect( ui_sfx_play.bind(&"Message").unbind(1) )

		# recursion
		install_sounds(i)


func ui_sfx_play(sound : String) -> void:
#	printt("Playing sound:", sound)
	sounds[sound].play()
