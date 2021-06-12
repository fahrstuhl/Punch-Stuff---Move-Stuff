extends Spatial

var moving = false
var target = Vector3()
var t = 0

func _physics_process(delta):
	if moving:
		t += delta
		var weight = t/0.5
		if weight < 1: 
			translation = translation.linear_interpolate(target, weight)
		else:
			translation = target
		

func _on_moving(direction):
	moving = true
	target = translation + 40*direction
	print("Origin: ", translation, " Target: ", target, " Direction: ", direction)
