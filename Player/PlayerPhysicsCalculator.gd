var horizontal_velocity_override = 0
var vertical_velocity_override = 0

const ACCELERATION = 800
const MAX_SPEED = 80
const ROLL_SPEED = 120
const FRICTION = 800

func calculate_movement(prev_velocity: Vector2, roll_vector: Vector2, delta: float):
  set_horizontal_velocity_override()
  set_vertical_velocity_override()

  var input_vector = calculate_and_normalize_input_vector()

  var is_moving = input_vector != Vector2.ZERO

  if is_moving:
    roll_vector = input_vector

  var new_velocity = calculate_new_velocity(input_vector, is_moving, prev_velocity, delta)

  return [new_velocity, is_moving, input_vector, roll_vector]

func calculate_roll(roll_vector: Vector2, _delta: float):
  return roll_vector * ROLL_SPEED

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

func calculate_and_normalize_input_vector():
  var input_vector = Vector2.ZERO

  input_vector.x = calculate_horizontal_velocity()
  input_vector.y = calculate_vertical_velocity()

  return input_vector.normalized()

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

func calculate_new_velocity(input_vector: Vector2, is_moving: bool, prev_velocity: Vector2, delta: float):
  if(is_moving):
    return prev_velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
  else:
    return prev_velocity.move_toward(Vector2.ZERO, FRICTION * delta)