extends KinematicBody2D

# Called when the node enters the scene tree for the first time.
# func _ready():
#   print("Hello, world!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass

var velocity = Vector2.ZERO

const PlayerMovementCalculator = preload("PlayerMovementCalculator.gd")
const PlayerAnimationProcessor = preload("PlayerAnimationProcessor.gd")

onready var animation_tree: AnimationTree = $AnimationTree

onready var movement_calculator = PlayerMovementCalculator.new()
onready var animation_processor = PlayerAnimationProcessor.new(animation_tree)

func _physics_process(delta):
  var movement_result = movement_calculator.calculate(velocity, delta)

  var input_vector = movement_result[0]
  var is_moving = movement_result[1]
  var new_velocity = movement_result[2]

  animation_processor.process(input_vector, is_moving)

  velocity = move_and_slide(new_velocity)
