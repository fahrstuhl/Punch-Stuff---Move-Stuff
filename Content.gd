extends Spatial

func _process(delta):
	move_camera(delta)

func move_camera(delta):
	var p = $Player.translation
	var c = $Camera.translation
	#print("{0} - Player\n{1} - Camera".format([p,c]))
	c.x = clamp(c.x, p.x-5, p.x+5)
	c.y = clamp(c.y, p.y-5, p.y+5)
	$Camera.translation = c
	#$Camera.look_at($Player.translation, Vector3(0,1,0))
