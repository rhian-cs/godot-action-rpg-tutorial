extends KinematicBody2D

const PlayerMovementCalculator = preload("PlayerMovementCalculator.gd")
const PlayerAnimationProcessor = preload("PlayerAnimationProcessor.gd")

onready var animation_tree: AnimationTree = $AnimationTree

onready var movement_calculator = PlayerMovementCalculator.new()
onready var animation_processor = PlayerAnimationProcessor.new(animation_tree)

enum {
  MOVE = 10,
  ROLL = 20,
  ATTACK = 30
}

var velocity = Vector2.ZERO
var state = MOVE

func _physics_process(delta: float):
  match(state):
    MOVE:
      move_state(delta)
    ROLL:
      pass
    ATTACK:
      attack_state()

func move_state(delta: float):
  var movement_result = movement_calculator.calculate(velocity, delta)

  var input_vector = movement_result[0]
  var is_moving = movement_result[1]
  var new_velocity = movement_result[2]

  animation_processor.process_movement(input_vector, is_moving)

  velocity = move_and_slide(new_velocity)

  if Input.is_action_just_pressed("attack"):
    state = ATTACK

func attack_state():
  velocity = Vector2.ZERO
  animation_processor.process_attack()

func on_attack_animation_finished():
  state = MOVE
