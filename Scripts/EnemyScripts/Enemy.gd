class_name Enemy
extends Entity

@export
var ATTACK_RANGE = 1.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#simple function that will deal damage to the entity
func takeDamage(damage):
	if current_HP<damage:
		current_HP = 0
		queue_free()
	else:
		current_HP -= damage
#Function that will add velocity to object in order to follow player
func followPlayer():
	#getting the player for position values
	var player = get_tree().get_nodes_in_group("PlayerGroup")[0]

	var xdist = player.position.x - position.x
	var zdist = player.position.z - position.z
	#use pythag to find the distance between enemy & player
	#var playerDist = sqrt(xdist*xdist + zdist*zdist)
	#calculates velocity based on given speed
	var chaseVelx = cos(atan(zdist/xdist))* current_speed * (xdist/abs(xdist))
	var chaseVelz = cos(atan(xdist/zdist))* current_speed * (zdist/abs(zdist))
	#print("x:"+str(xdist)+" | z:"+str(zdist)+" | dist:"+str(playerDist)+"\nChase X: "+str(chaseVelx)+" | Chase Z:"+str(chaseVelz))
	velocity.x = chaseVelx
	velocity.z = chaseVelz
	
	#print("Lerp value:"+str(lerp(player.position.x,player.position.y,player.position.z)))
func isInAttackRange():
	#get player
	var player = get_tree().get_nodes_in_group("PlayerGroup")[0]
	var xdist = player.position.x - position.x
	var zdist = player.position.z - position.z
	#use pythag to find the distance between enemy & player
	var playerDist = sqrt(xdist*xdist + zdist*zdist)
	#testing purposes
	
	if(playerDist <= ATTACK_RANGE):
		return true
	else:
		return false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Enemys")
	

