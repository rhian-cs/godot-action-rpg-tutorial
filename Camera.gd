extends Camera2D

onready var top_left = $Limits/TopLeftCameraLimit
onready var bottom_right = $Limits/BottomRightCameraLimit

# Called when the node enters the scene tree for the first time.
func _ready():
  limit_top = top_left.position.y
  limit_left = top_left.position.x
  limit_bottom = bottom_right.position.y
  limit_right = bottom_right.position.x
