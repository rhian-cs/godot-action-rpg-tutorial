extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

const FRICTION  = 200
const KNOCKBACK_FACTOR = 120

onready var stats = $Stats

var knockback = Vector2.ZERO

func _physics_process(delta):
  knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
  knockback = move_and_slide(knockback)

func _on_Hurtbox_area_entered(area: Area2D):
  stats.health -= area.damage

  knockback = area.knockback_vector * KNOCKBACK_FACTOR

func _on_Stats_no_health():
  create_effect()
  queue_free()

func create_effect():
  var enemy_death_effect = EnemyDeathEffect.instance()

  get_parent().add_child(enemy_death_effect)
  enemy_death_effect.global_position = global_position