var animation_tree: AnimationTree
var animation_state: AnimationNodeStateMachinePlayback
var animation_player: AnimationPlayer

func _init(player_animation_tree: AnimationTree):
  animation_tree = player_animation_tree
  animation_tree.active = true

  animation_state = animation_tree.get("parameters/playback")

func process_movement(input_vector, is_moving):
  if(is_moving):
    animation_tree.set("parameters/Idle/blend_position", input_vector)
    animation_tree.set("parameters/Run/blend_position", input_vector)
    animation_tree.set("parameters/Attack/blend_position", input_vector)
    animation_tree.set("parameters/Roll/blend_position", input_vector)

    animation_state.travel("Run")
  else:
    animation_state.travel("Idle")

func process_attack():
  animation_state.travel("Attack")

func process_roll():
  animation_state.travel("Roll")
