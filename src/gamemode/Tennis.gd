extends Node2D
class_name Tennis


const CAMERA_SHAKE_REFERENCE_POINT = 600
const BALL_RECOVERY_TIME = 2 # seconds

export var ball_scene: PackedScene
export var counting_ball_kicks = true
export var ball_kicks_to_fail = 2
export var points_to_win = 5
export var duration = 4 * 60 # 5 minutes

onready var camera_shake = $Camera2D/Shake
onready var game_layer = $Game
onready var field = $Game/Field
onready var score_display = $ScoreDisplay
onready var highlight = $Highlight
onready var person1 = $Game/Person1
onready var person2 = $Game/Person2
onready var state_machine = $StateMachine
onready var sound_hit_floor = $Sound/HitFloor
onready var sound_hit_racket = $Sound/HitRacket
onready var sound_score = $Sound/Score
onready var sound_win = $Sound/Win

var ball: Ball
var points_char1 = 0
var points_char2 = 0
var next_holder = Enums.BallHolder.Player1
var time_of_play = 0


func apply_camera_shake(strength):
	var shake_strength = strength / CAMERA_SHAKE_REFERENCE_POINT
	camera_shake.impact(camera_shake.default_time, shake_strength)


func update_displays():
	$"DebugNode/PointsChar1Label".text = 'points char1: ' + str(points_char1)
	$"DebugNode/PointsChar2Label".text = 'points char2: ' + str(points_char2)
	score_display.set_char1(points_char1)
	score_display.set_char2(points_char2)


func _on_Person_attack_executed(strength):
	apply_camera_shake(strength)
	sound_hit_racket.play()


func _on_StateMachine_transition(state_name):
	$DebugNode/StateLabel.text = str('state: ', state_name)
