extends Node2D

func _process(_delta: float):
  if Input.is_action_just_pressed("attack"):
    trigger_destruction()

func trigger_destruction():
  load_effect()
  queue_free()

func load_effect():
  var GrassEffect = load("res://Effects/GrassEffect.tscn")
  var grass_effect = GrassEffect.instance()

  var world = get_tree().current_scene

  world.add_child(grass_effect)
  grass_effect.global_position = global_position
