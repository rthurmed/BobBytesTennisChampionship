extends Node2D
class_name Stage


signal scored_point(is_by_char1)
signal gameover(is_char1_winner)

const CAMERA_SHAKE_REFERENCE_POINT = 600
const BALL_RECOVERY_TIME = 2 # seconds

export var ball_scene: PackedScene
export var counting_ball_kicks = true
export var ball_kicks_to_fail = 2
export var points_to_win = 5

onready var camera_shake = $Camera2D/Shake
onready var ball_start_position_char1 = $Layers/Positions/BallStart/Char1
onready var ball_start_position_char2 = $Layers/Positions/BallStart/Char2
onready var game_layer = $Layers/Game
onready var score_label_char1 = $Layers/Backdrop/ScoreDisplay/LabelChar1
onready var score_label_char2 = $Layers/Backdrop/ScoreDisplay/LabelChar2
onready var floor_highlight = $Layers/Backdrop/Floor/Highlight

var ball: Ball
var ball_on_char1 = true
var ball_kicks = 0
var points_char1 = 0
var points_char2 = 0


func _ready():
	spawn_new_ball(ball_on_char1)


func apply_camera_shake(strength):
	var shake_strength = strength / CAMERA_SHAKE_REFERENCE_POINT
	camera_shake.impact(camera_shake.default_time, shake_strength)


func _on_Person_attack_executed(strength):
	apply_camera_shake(strength)
	$Sounds/HitRacket.play()


func _on_Ball_touched_floor():
	if not counting_ball_kicks:
		return
	
	ball_kicks = ball_kicks + 1
	$DebugNode/KicksLabel.text = 'kicks: ' + str(ball_kicks)
	
	if ball_kicks >= ball_kicks_to_fail:
		emit_signal("scored_point", not ball_on_char1)
		return
	
	if ball_kicks == ball_kicks_to_fail - 1:
		floor_highlight.blink(ball_on_char1)
	
	$Sounds/HitFloor.play()


func _on_FieldTransitionArea_body_exited(body):
	if not body.is_in_group('ball'):
		return
	
	ball_on_char1 = not ball_on_char1
	ball_kicks = 0
	
	$DebugNode/FocusedLabel.text = 'focused: ' + str('char1' if ball_on_char1 else 'char2')
	$DebugNode/KicksLabel.text = 'kicks: ' + str(ball_kicks)
	
	floor_highlight.stop()


func _on_Main_scored_point(is_by_char1):
	## disable stage state
	#counting_ball_kicks = false
	#ball.set_state(false)
	
	# update scores
	if is_by_char1:
		points_char1 += 1
	else:
		points_char2 += 1
	
	$DebugNode/PointsChar1Label.text = 'points char1: ' + str(points_char1)
	$DebugNode/PointsChar2Label.text = 'points char2: ' + str(points_char2)
	
	score_label_char1.text = str("%02d" % points_char1)
	score_label_char2.text = str("%02d" % points_char2)
	
	# is the last point?
	if (
		points_char1 >= points_to_win or
		points_char2 >= points_to_win
	):
		emit_signal("gameover", is_by_char1)
		return
	
	# reset visual
	floor_highlight.stop()
	
	# fancy sounds
	$Sounds/Score.play()
	
	# reset ball
	# TODO: maybe wait a little bit
	ball.queue_free()
	ball_kicks = 0
	ball_on_char1 = is_by_char1
	spawn_new_ball(is_by_char1)
	
	$DebugNode/FocusedLabel.text = 'focused: ' + str('char1' if ball_on_char1 else 'char2')
	$DebugNode/KicksLabel.text = 'kicks: ' + str(ball_kicks)


func spawn_new_ball(to_char1):
	var target_position = ball_start_position_char1.global_position
	if not to_char1:
		target_position = ball_start_position_char2.global_position
	
	ball = ball_scene.instance()
	ball.global_position = target_position
	var _ok = ball.connect("touched_floor", self, "_on_Ball_touched_floor")
	
	game_layer.call_deferred("add_child", ball)


func _on_Main_gameover(_is_char1_winner):
	counting_ball_kicks = false
	ball.set_state(false)
	# TODO: congratulate winner
