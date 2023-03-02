extends State


onready var ball_start_position_char1 = $"../../Layers/Positions/BallStart/Char1".global_position
onready var ball_start_position_char2 = $"../../Layers/Positions/BallStart/Char2".global_position
onready var animation = $AnimationPlayer
onready var person1 = $"../../Layers/Game/Person1"
onready var person2 = $"../../Layers/Game/Person2"

var ball_kicks = 0


func handle_input(_event: InputEvent): pass
func process(_delta: float): pass
func physics_process(_delta: float): pass


func enter():
	ball_kicks = 0
	spawn_new_ball()
	animation.play("increasing_strength")


func exit():
	animation.stop(true)
	person1.attack_strength_modifier = 0
	person2.attack_strength_modifier = 0


func spawn_new_ball():
	var target_position = ball_start_position_char1
	if not owner.ball_on_char1:
		target_position = ball_start_position_char2
	
	owner.ball = owner.ball_scene.instance()
	owner.ball.global_position = target_position
	var _ok = owner.ball.connect("touched_floor", self, "_on_Ball_touched_floor")
	
	owner.game_layer.call_deferred("add_child", owner.ball)
	
	$"../../DebugNode/FocusedLabel".text = 'focused: ' + str('char1' if owner.ball_on_char1 else 'char2')
	$"../../DebugNode/KicksLabel".text = 'kicks: ' + str(ball_kicks)


func _on_Ball_touched_floor():
	if not active(): return
	
	owner.sound_hit_floor.play()
	
	ball_kicks = ball_kicks + 1
	$"../../DebugNode/KicksLabel".text = 'kicks: ' + str(ball_kicks)
	
	if ball_kicks >= owner.ball_kicks_to_fail:
		transition("Point")
		return
	
	if ball_kicks == owner.ball_kicks_to_fail - 1:
		owner.floor_highlight.blink(owner.ball_on_char1)


func _on_FieldTransitionArea_body_exited(body):
	if not active(): return
	if not body.is_in_group('ball'): return
	
	# FIXME: possible to bug this if the ball falls to the same side
	# use 2 full field areas to register the transition
	
	owner.ball_on_char1 = not owner.ball_on_char1
	ball_kicks = 0
	
	$"../../DebugNode/FocusedLabel".text = 'focused: ' + str('char1' if owner.ball_on_char1 else 'char2')
	$"../../DebugNode/KicksLabel".text = 'kicks: ' + str(ball_kicks)
	
	owner.floor_highlight.stop()
