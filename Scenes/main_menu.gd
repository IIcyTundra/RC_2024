extends Control

@export var Animator : AnimationPlayer
@export var Buttons : VBoxContainer
@export var MenuStart : Label

# Called when the node enters the scene tree for the first time.
func _ready():
	Animator.play("TextFade")
	Buttons.visible = false	

func _unhandled_key_input(event):
	if event.is_pressed():
		Animator.stop()
		Buttons.visible = true
		MenuStart.visible = false
func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Map1.tscn")


func _on_button_2_pressed():
	pass # Replace with function body.


func _on_button_3_pressed():
	pass # Replace with function body.
