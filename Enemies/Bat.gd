extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export (float) var knockback_friction = 200.0
export (float) var knockback_factor = 200.0
export (float) var movement_friction = 400.0
export (float) var max_speed = 60.0
export (float) var acceleration = 600.0
export (float) var soft_collision_factor = 400.0

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var player_detection_zone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var soft_collision = $SoftCollision

enum {
  IDLE = 10,
  WANDER = 20,
  CHASE = 30
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var state = CHASE

func _physics_process(delta):
  process_knockback(delta)
  process_movement(delta)

  match state:
    IDLE:
      idle_state(delta)
    WANDER:
      pass
    CHASE:
      chase_state(delta)

func process_knockback(delta):
  # Decrease knockback and then apply it
  knockback = knockback.move_toward(Vector2.ZERO, knockback_friction * delta)
  knockback = move_and_slide(knockback)

func process_movement(delta):
  if soft_collision.is_colliding():
    velocity += soft_collision.get_push_vector() * delta * soft_collision_factor
  velocity = move_and_slide(velocity)

func update_sprite_direction():
  sprite.flip_h = velocity.x < 0

func idle_state(delta):
  velocity = velocity.move_toward(Vector2.ZERO, movement_friction * delta)

  check_for_player()

func check_for_player():
  if player_detection_zone.can_see_player():
    state = CHASE

func chase_state(delta):
  update_sprite_direction()

  if player_detection_zone.can_see_player():
    chase_player(delta)
  else:
    state = IDLE

func chase_player(delta):
  var player = player_detection_zone.player
  var player_direction = (player.global_position - global_position).normalized()

  velocity = velocity.move_toward(player_direction * max_speed, acceleration * delta)

func create_death_effect():
  var enemy_death_effect = EnemyDeathEffect.instance()

  get_parent().add_child(enemy_death_effect)
  enemy_death_effect.global_position = global_position

# Signals

func _on_Hurtbox_area_entered(area: Area2D):
  stats.health -= area.damage
  hurtbox.create_hit_effect()

  knockback = area.knockback_vector * knockback_factor

func _on_Stats_no_health():
  create_death_effect()
  queue_free()
