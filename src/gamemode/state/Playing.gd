extends State


onready var animation = $AnimationPlayer
onready var person1 = $"../../Game/Person1"
onready var person2 = $"../../Game/Person2"

var ball_kicks = 0


func process(delta: float):
	owner.time_of_play += delta
	owner.score_display.set_time(owner.duration - owner.time_of_play)
	
	if owner.time_of_play > owner.duration:
		transition("Gameover")
		return


func enter():
	ball_kicks = 0
	spawn_new_ball()
	# TODO: replace animation with something manual on process()
	# using lerp() and clamp()
	animation.play("increasing_strength")


func exit():
	animation.stop(true)
	person1.attack_strength_modifier = 0
	person2.attack_strength_modifier = 0


func spawn_new_ball():
	var target_position = owner.field.ball_start1.global_position
	if owner.next_holder == Enums.BallHolder.Player2:
		target_position = owner.field.ball_start2.global_position
	
	owner.ball = owner.ball_scene.instance()
	owner.ball.global_position = target_position
	var _ok = owner.ball.connect("touched_floor", self, "_on_Ball_touched_floor")
	
	owner.game_layer.call_deferred("add_child", owner.ball)
	
	$"../../DebugNode/FocusedLabel".text = 'focused: ' + str('char', owner.ball.holder)
	$"../../DebugNode/KicksLabel".text = 'kicks: ' + str(owner.ball.kicks)


func _on_Ball_touched_floor():
	if not active(): return
	
	owner.sound_hit_floor.play()
	
	owner.ball.kicks = owner.ball.kicks + 1
	$"../../DebugNode/KicksLabel".text = 'kicks: ' + str(owner.ball.kicks)
	
	if owner.ball.kicks >= owner.ball_kicks_to_fail:
		transition("Point")
		return
	
	if owner.ball.kicks == owner.ball_kicks_to_fail - 1:
		owner.highlight.blink(owner.ball.holder)


func _on_Field_changed_field(ball):
	ball.kicks = 0
	
	$"../../DebugNode/FocusedLabel".text = 'focused: ' + str('char', owner.ball.holder)
	$"../../DebugNode/KicksLabel".text = 'kicks: ' + str(owner.ball.kicks)
	
	owner.highlight.stop()
