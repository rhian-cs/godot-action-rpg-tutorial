extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

export (bool) var show_hit = true

func _ready():
  pass

func _on_Hurtbox_area_entered(area):
  if show_hit:
    create_hit_effect()

func create_hit_effect():
  var effect = HitEffect.instance()

  var world = get_tree().current_scene
  world.add_child(effect)

  effect.global_position = global_position
