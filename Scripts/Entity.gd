extends CharacterBody3D
class_name Entity

@export var max_HP : int = 100
@export var current_HP : int = 100 
@export var max_SP : int = 100
@export var current_SP : int = 100
@export var max_AP : int = 100
@export var current_AP : int = 100

@export var max_speed : int = 100 #Entity Walk Speed
@export var current_speed : int = 50 #Entity Run Speed

@export var base_damage : int = 10 #Base Damage an Entity can output
@export var base_HP_regen : int = 1 #Base Health regen
@export var base_SP_regen : int = 1 #Base Skill Point regen


func regen_HP(stat_bonus):
	if(current_HP < max_HP):
		if(base_HP_regen + current_HP) > max_HP:
			current_HP = max_HP
		else: current_HP += (base_HP_regen + stat_bonus)

func regen_SP(stat_bonus):
	if(current_SP < max_SP):
		if(base_SP_regen + current_SP) > max_SP:
			current_SP = max_SP
		else: current_SP += (base_SP_regen + stat_bonus)
		
func modify_SP(stat_bonus):
	var new_SP = current_SP + stat_bonus
	if(new_SP < 0): current_SP = 0
	if(new_SP > max_SP): current_SP = max_SP
	else: current_SP += stat_bonus
	
func modify_AP(stat_bonus):
	var new_AP = current_AP + stat_bonus
	if(new_AP < 0): current_AP = 0
	if(new_AP > max_AP): current_AP = max_AP
	else: current_AP += stat_bonus
	
	
func load_ability(name):
	var scene = load("res://Abilities/" + name + "/" + name + ".tscn")
	if scene == null:
		
		push_error("The Ability you tried to load doesn't exist! Make sure you named it correctly.")
	var sceneNode = scene.instance()
	add_child(sceneNode)
	return sceneNode
