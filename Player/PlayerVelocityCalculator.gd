var velocity = Vector2.ZERO

var horizontal_velocity_override = 0
var vertical_velocity_override = 0

const ACCELERATION = 25
const MAX_SPEED = 100
const FRICTION = 15

func calculate(delta):
	var input_vector = Vector2.ZERO

	set_horizontal_velocity_override()
	set_vertical_velocity_override()

	input_vector.x = calculate_horizontal_velocity()
	input_vector.y = calculate_vertical_velocity()

	if(input_vector != Vector2.ZERO):
		velocity += input_vector.normalized() * ACCELERATION * delta
		velocity = velocity.clamped(MAX_SPEED * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	return velocity

func set_horizontal_velocity_override():
	if(Input.is_action_just_pressed("ui_left")):
		horizontal_velocity_override = -1
	if(Input.is_action_just_pressed("ui_right")):
		horizontal_velocity_override =  1

func set_vertical_velocity_override():
	if(Input.is_action_just_pressed("ui_up")):
		vertical_velocity_override = -1
	if(Input.is_action_just_pressed("ui_down")):
		vertical_velocity_override = 1


func calculate_horizontal_velocity():
	var right_strength = Input.get_action_strength("ui_right")
	var left_strength = Input.get_action_strength("ui_left")

	if(right_strength && left_strength):
		return horizontal_velocity_override

	return right_strength - left_strength

func calculate_vertical_velocity():
	var down_strength = Input.get_action_strength("ui_down")
	var up_strength = Input.get_action_strength("ui_up")

	if(down_strength && up_strength):
		return vertical_velocity_override

	return down_strength - up_strength