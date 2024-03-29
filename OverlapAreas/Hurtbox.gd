extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

signal invincibility_started
signal invincibility_ended

onready var invincibility_timer = $InvincibilityTimer
onready var collision_shape = $CollisionShape2D

var invincible: bool = false setget set_invincible

func set_invincible(value: bool):
  invincible = value

  if invincible == true:
    emit_signal("invincibility_started")
  else:
    emit_signal("invincibility_ended")

func start_invincibility(duration):
  self.invincible = true
  invincibility_timer.start(duration)

func create_hit_effect():
  var effect = HitEffect.instance()

  var world = get_tree().current_scene
  world.add_child(effect)

  effect.global_position = global_position

func _on_InvincibilityTimer_timeout():
  self.invincible = false

# Resetting Hurtbox
func _on_Hurtbox_invincibility_started():
  collision_shape.set_deferred("disabled", true)

func _on_Hurtbox_invincibility_ended():
  collision_shape.disabled = false
