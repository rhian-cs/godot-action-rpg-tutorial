extends KinematicBody2D

export (float) var acceleration = 800.0
export (float) var max_speed = 80.0
export (float) var roll_speed = 140.0
export (float) var friction = 800.0

const PlayerPhysicsCalculator = preload("PlayerPhysicsCalculator.gd")
const PlayerAnimationProcessor = preload("PlayerAnimationProcessor.gd")

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")

onready var animation_tree: AnimationTree = $AnimationTree
onready var sword_hitbox: Area2D = $HitboxPivot/SwordHitbox
onready var hurtbox: Area2D = $Hurtbox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer

onready var physics_calculator = PlayerPhysicsCalculator.new(acceleration, max_speed, roll_speed, friction)
onready var animation_processor = PlayerAnimationProcessor.new(animation_tree)

const INVINCIBILITY_TIME = 0.5

enum {
  MOVE = 10,
  ROLL = 20,
  ATTACK = 30
}

var velocity: Vector2 = Vector2.ZERO
var roll_vector: Vector2 = Vector2.DOWN
var state: int = MOVE
var stats = PlayerStats

func _ready():
  randomize()
  stats.connect("no_health", self, "queue_free")
  update_sword_hitbox()

func update_sword_hitbox():
  sword_hitbox.knockback_vector = roll_vector

func _physics_process(delta: float):
  match(state):
    MOVE:
      move_state(delta)
    ROLL:
      roll_state(delta)
    ATTACK:
      attack_state()

func move_state(delta: float):
  var physics_result = physics_calculator.calculate_movement(velocity, roll_vector, delta)

  var new_velocity = physics_result[0]
  var is_moving = physics_result[1]
  var input_vector = physics_result[2]
  roll_vector = physics_result[3]

  update_sword_hitbox()

  animation_processor.process_movement(input_vector, is_moving)

  move(new_velocity)

  if Input.is_action_just_pressed("attack"):
    state = ATTACK

  if Input.is_action_just_pressed("roll"):
    state = ROLL

func roll_state(delta: float):
  var new_velocity = physics_calculator.calculate_roll(roll_vector, delta)

  move(new_velocity)
  animation_processor.process_roll()

func attack_state():
  velocity = Vector2.ZERO
  animation_processor.process_attack()

func move(new_velocity):
  velocity = move_and_slide(new_velocity)


func play_hurt_sound():
  var playerHurtSound = PlayerHurtSound.instance()
  get_tree().current_scene.add_child(playerHurtSound)

# Signals

func on_attack_animation_finished():
  velocity = Vector2.ZERO
  state = MOVE

func on_roll_animation_finished():
  state = MOVE

func _on_Hurtbox_area_entered(area: Area2D):
  hurtbox.start_invincibility(INVINCIBILITY_TIME)
  hurtbox.create_hit_effect()
  stats.health -= area.damage

  play_hurt_sound()

func _on_Hurtbox_invincibility_started():
  blinkAnimationPlayer.play("Start")

func _on_Hurtbox_invincibility_ended():
  blinkAnimationPlayer.play("Stop")
