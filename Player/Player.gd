extends KinematicBody2D

# Called when the node enters the scene tree for the first time.
# func _ready():
#   print("Hello, world!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass

const PlayerVelocityCalculator = preload("PlayerVelocityCalculator.gd")
onready var player_velocity_calculator = PlayerVelocityCalculator.new()

var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer

func _physics_process(delta):
  velocity = player_velocity_calculator.calculate(animationPlayer, velocity, delta)

  velocity = move_and_slide(velocity)
