extends Control

onready var heart_ui_full = $HeartUIFull
onready var heart_ui_empty = $HeartUIEmpty

const HEART_WIDTH = 15

var hearts = 4 setget set_hearts
var max_hearts setget set_max_hearts

func set_hearts(value):
  hearts = clamp(value, 0, max_hearts)

  if heart_ui_full != null:
    update_hearts_ui_full()

func set_max_hearts(value):
  max_hearts = max(value, 1)

  self.hearts = min(hearts, max_hearts)

  if heart_ui_empty != null:
    update_heart_ui_empty()

func _ready():
  self.max_hearts = PlayerStats.max_health
  self.hearts = PlayerStats.health

  PlayerStats.connect("health_changed", self, "set_hearts") # warning-ignore:return_value_discarded
  PlayerStats.connect("max_health_changed", self, "set_max_hearts") # warning-ignore:return_value_discarded

func update_hearts_ui_full():
  heart_ui_full.rect_size.x = hearts * HEART_WIDTH

func update_heart_ui_empty():
  heart_ui_empty.rect_size.x = max_hearts * HEART_WIDTH
