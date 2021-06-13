extends KinematicBody

var ACCELERATION = 5
var JUMP_ACCELERATION = 200
var SPEED = 20
var FALL_SPEED = 60
var GRAVITY = 2
var JUMP_SPEED = 35
var DASH_SPEED = 50
var JUMP_MAX_HOLD_TIME = 0.175
var COYOTE_TIME = 0.15
var DASH_TIME = 0.3
var DASH_ACC = 1

var UP = Vector3(0,1,0)
var velocity = Vector3()
var dash_direction = 1
var up = 0
var down = 0
var left = 0
var right = 0
var dashing = false
var can_dash = false
var jumped = false
var in_air = false
var can_jump = false
var jump_acceleration = 0

func _physics_process(delta):
	handle_jump()
	move(delta)

func handle_jump():
	#acceleration_jump()
	velocity_curve_jump()

func move(delta):
	#acceleration_move(delta)
	velocity_curve_move(delta)

func velocity_curve_jump():
	pass

func velocity_curve_move(delta):
	var x = velocity.x
	var y = velocity.y
	var x_acc = 0
	var y_acc = 0
	var dash_vel_x = 0
	var dash_acc_y = 0
	var gravity_acc = -GRAVITY
	var break_acc = 0
	
	var direction = right-left
	var dash_steer = up-down
	if left or right:
		# changing direction?
		# acceleration?
		x = direction * SPEED

	if not is_on_floor():
		gravity_acc = -GRAVITY

	if not $Dash.is_stopped():
		if not dashing:
			dashing = true
			if direction > 0:
				dash_direction = 1
			elif direction < 0:
				dash_direction = -1
			y = 0
		dash_vel_x = dash_direction * DASH_SPEED
		dash_acc_y = dash_steer * DASH_ACC
		gravity_acc = 0
		x = dash_vel_x
	else:
		dashing = false

	if not left and not right and $Dash.is_stopped():
		break_acc = -sign(x) * ACCELERATION
		if abs(x) <= abs(break_acc):
			x = 0
		else:
			x += break_acc

	if jumped and not $JumpHold.is_stopped():
		var jump_strength = $JumpHold.time_left / $JumpHold.wait_time
		#print("time left: {0}\nwait time:{1}\njump strength: {2}".format([$JumpHold.time_left, $JumpHold.wait_time, jump_strength]))
		y = JUMP_SPEED

	y = y + gravity_acc + dash_acc_y
	y = clamp(y, -FALL_SPEED, JUMP_SPEED)
	velocity.x = x
	velocity.y = y
	velocity.z = 0
	velocity = move_and_slide(velocity, UP, false, 2)
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		if collision.collider.has_method("collided_with_player"):
			collision.collider.collided_with_player(collision.normal)
	if is_on_floor():
		can_jump = true
		jumped = false
		in_air = false
		can_dash = true
		$Coyote.stop()
	else:
		if can_jump_colliding():
			can_jump = not jumped or in_air
			print("Can jump: {0}, In Air: {1}, Jumped: {2}".format([can_jump, in_air, jumped]))
		else:
			if not in_air and can_jump and $Coyote.is_stopped():
				$Coyote.start(COYOTE_TIME)
				print("starting coyote time")
			elif $Coyote.is_stopped() or jumped:
				can_jump = false
				$Coyote.stop()
			in_air = true


func can_jump_colliding():
	return $CanJump1.is_colliding() or $CanJump2.is_colliding() or $CanJump3.is_colliding()

func dash():
	if can_dash and $Dash.is_stopped():
		$Dash.start(DASH_TIME)
		can_dash = false
	elif not $Dash.is_stopped():
		$Dash.stop()

func jump(event):
	if event.is_action_pressed("jump") and can_jump:
		jumped  = true
		$JumpHold.start(JUMP_MAX_HOLD_TIME)
	if event.is_action_released("jump"):
		$JumpHold.stop()

func _input(event):
	if event.is_action("ui_left"):
		left = int(event.is_action_pressed("ui_left"))
	if event.is_action("ui_up"):
		up = int(event.is_action_pressed("ui_up"))
	if event.is_action("ui_down"):
		down = int(event.is_action_pressed("ui_down"))
	if event.is_action("ui_right"):
		right = int(event.is_action_pressed("ui_right"))
	if event.is_action("jump"):
		jump(event)
	if event.is_action_pressed("dash"):
		dash()


func _on_Coyote_timeout():
	print("coyote time stopped")
