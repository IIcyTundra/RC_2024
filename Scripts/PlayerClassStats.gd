extends Resource
class_name Player_Base_Stats

const ABILITY_SLOT_MAX : int = 3
@export var player_name : String
@export_enum("Light", "Medium", "Heavy") var player_class : String
@export var base_HP : int 
@export var base_SP : int 
@export var base_AP : int
@export var base_speed : int 
@export var base_stamina : int
@export var abilities : Array = []
