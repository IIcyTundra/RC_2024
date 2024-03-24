extends Node3D

var enemy_scene = preload("res://EnemyScenes/BasicEnemy.tscn")

func _on_timer_timeout():
	var enemy = enemy_scene.instantiate()
	enemy.position = Vector3(4,2,3)
	add_child(enemy)
	print("enemyspawned")
