var animation_tree: AnimationTree
var animation_state: AnimationNodeStateMachinePlayback

func _init(player_animation_tree: AnimationTree):
  animation_tree = player_animation_tree
  animation_state = animation_tree.get("parameters/playback")

func process(input_vector, is_moving):
  if(is_moving):
    animation_tree.set("parameters/Idle/blend_position", input_vector)
    animation_tree.set("parameters/Run/blend_position", input_vector)

    animation_state.travel("Run")
  else:
    animation_state.travel("Idle")
