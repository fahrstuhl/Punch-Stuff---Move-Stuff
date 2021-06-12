extends Spatial

export(bool) var UP = false
export(bool) var LEFT = false
export(bool) var DOWN = false
export(bool) var RIGHT = false

signal moving(direction)

var moving = false
var normal = Vector3()
var t = 0
var target = Vector3()

func _ready():
	$Cuboid.connect("collided_with_player", self, "collided_with_player")

func _physics_process(delta):
	if moving:
		t += delta * 10
		translation = translation.linear_interpolate(target, t)

func collided_with_player(collision_normal):
	if moving:
		return
	if (abs(collision_normal.x) > abs(collision_normal.y)):
		normal = Vector3(-sign(collision_normal.x), 0, 0)
	else:
		normal = Vector3(0, -sign(collision_normal.y), 0)
	if (UP and normal.y > 0) or (DOWN and normal.y < 0) or (LEFT and normal.x < 0) or (RIGHT and normal.x > 0):
		moving = true
		t = 0
		target = translation + normal * 4
		print("Target: ", target, " Normal: ", normal)
		emit_signal("moving", normal)
