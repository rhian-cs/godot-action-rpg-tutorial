extends KinematicBody2D

# Called when the node enters the scene tree for the first time.
# func _ready():
# 	print("Hello, world!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

const PlayerVelocityCalculator = preload("PlayerVelocityCalculator.gd")
onready var player_velocity_calculator = PlayerVelocityCalculator.new()

func _physics_process(delta):
	move_and_collide(player_velocity_calculator.calculate(delta))
