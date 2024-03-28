extends Node

func _process(delta):
	var input = Input.is_action_pressed("jump")
	if input == true:
		var enemies = get_tree().get_nodes_in_group("Enemys")
		for x in enemies:
			x.takeDamage(5,100)
