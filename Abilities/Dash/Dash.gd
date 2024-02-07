extends Entity

@export var speed_multiplier : int
@export var cooldown : int = 1
@export var timer : Timer
@export var ended : bool = false
var prev_speed
func execute(s, direction = null):
	if !ended:
		prev_speed = s.current_speed
		s.current_speed *= speed_multiplier
	else:
		s.current_speed = prev_speed
		ended = false
	

func _on_timer_timeout():
	ended = true
