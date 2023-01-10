extends KinematicBody2D

const PlayerPhysicsCalculator = preload("PlayerPhysicsCalculator.gd")
const PlayerAnimationProcessor = preload("PlayerAnimationProcessor.gd")

onready var animation_tree: AnimationTree = $AnimationTree

onready var physics_calculator = PlayerPhysicsCalculator.new()
onready var animation_processor = PlayerAnimationProcessor.new(animation_tree)

enum {
  MOVE = 10,
  ROLL = 20,
  ATTACK = 30
}

var velocity: Vector2 = Vector2.ZERO
var roll_vector: Vector2 = Vector2.LEFT
var state: int = MOVE

func _physics_process(delta: float):
  match(state):
    MOVE:
      move_state(delta)
    ROLL:
      roll_state(delta)
    ATTACK:
      attack_state()

func move_state(delta: float):
  var physics_result = physics_calculator.calculate_movement(velocity, roll_vector, delta)

  var new_velocity = physics_result[0]
  var is_moving = physics_result[1]
  var input_vector = physics_result[2]
  roll_vector = physics_result[3]

  animation_processor.process_movement(input_vector, is_moving)

  move(new_velocity)

  if Input.is_action_just_pressed("attack"):
    state = ATTACK

  if Input.is_action_just_pressed("roll"):
    state = ROLL

func roll_state(delta: float):
  var new_velocity = physics_calculator.calculate_roll(roll_vector, delta)

  move(new_velocity)
  animation_processor.process_roll()

func attack_state():
  velocity = Vector2.ZERO
  animation_processor.process_attack()

func move(new_velocity):
  velocity = move_and_slide(new_velocity)

func on_attack_animation_finished():
  velocity = Vector2.ZERO
  state = MOVE

func on_roll_animation_finished():
  state = MOVE
