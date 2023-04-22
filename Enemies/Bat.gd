extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export (float) var knockback_friction = 200.0
export (float) var knockback_factor = 200.0
export (float) var movement_friction = 400.0
export (float) var max_speed = 60.0
export (float) var acceleration = 600.0
export (float) var soft_collision_factor = 400.0
export (float) var wander_target_range_limit = 4.0

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var player_detection_zone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var soft_collision = $SoftCollision
onready var wander_controller = $WanderController
onready var animation_player = $AnimationPlayer

enum {
  IDLE = 10,
  WANDER = 20,
  CHASE = 30
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var state = CHASE

func _ready():
  pick_random_state()

func _physics_process(delta):
  process_knockback(delta)
  process_movement(delta)

  match state:
    IDLE:
      idle_state(delta)
    WANDER:
      wander_state(delta)
    CHASE:
      chase_state(delta)

  update_sprite_direction()

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

  if wander_controller.get_time_left() == 0:
    update_movement_state_and_restart_timer()

func check_for_player():
  if player_detection_zone.can_see_player():
    state = CHASE

func update_movement_state_and_restart_timer():
    pick_random_state()
    wander_controller.start_wander_timer(rand_range(1, 3))

func wander_state(delta: float):
  check_for_player()

  if wander_controller.get_time_left() == 0:
    update_movement_state_and_restart_timer()

  accelerate_towards_position(wander_controller.target_position, delta)

  if global_position.distance_to(wander_controller.target_position) <= wander_target_range_limit:
    update_movement_state_and_restart_timer()

func chase_state(delta: float):
  if player_detection_zone.can_see_player():
    chase_player(delta)
  else:
    state = IDLE

func chase_player(delta: float):
  var player = player_detection_zone.player

  accelerate_towards_position(player.global_position, delta)

func accelerate_towards_position(target_global_position: Vector2, delta: float):
  var target_direction = global_position.direction_to(target_global_position)

  velocity = velocity.move_toward(target_direction * max_speed, acceleration * delta)

func create_death_effect():
  var enemy_death_effect = EnemyDeathEffect.instance()

  get_parent().add_child(enemy_death_effect)
  enemy_death_effect.global_position = global_position

func pick_random_state():
  var state_list = [IDLE, WANDER]
  state_list.shuffle()

  state = state_list.pop_front()

# Signals

func _on_Hurtbox_area_entered(area: Area2D):
  stats.health -= area.damage
  hurtbox.create_hit_effect()
  hurtbox.start_invincibility(0.4)

  knockback = area.knockback_vector * knockback_factor

func _on_Stats_no_health():
  create_death_effect()
  queue_free()


func _on_Hurtbox_invincibility_started():
  animation_player.play("Start")

func _on_Hurtbox_invincibility_ended():
  animation_player.play("Stop")
