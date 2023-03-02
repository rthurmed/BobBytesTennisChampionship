extends Node2D
class_name Stage


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
onready var score_label_char1 = $Layers/ScoreDisplay/LabelChar1
onready var score_label_char2 = $Layers/ScoreDisplay/LabelChar2
onready var floor_highlight = $Layers/Backdrop/Floor/Highlight
onready var sound_hit_floor = $Sound/HitFloor
onready var sound_hit_racket = $Sound/HitRacket
onready var sound_score = $Sound/Score
onready var sound_win = $Sound/Win

var ball: Ball
var ball_on_char1 = true
var points_char1 = 0
var points_char2 = 0


func apply_camera_shake(strength):
	var shake_strength = strength / CAMERA_SHAKE_REFERENCE_POINT
	camera_shake.impact(camera_shake.default_time, shake_strength)


func _on_Person_attack_executed(strength):
	apply_camera_shake(strength)
	sound_hit_racket.play()


func _on_StateMachine_transition(state_name):
	$DebugNode/StateLabel.text = str('state: ', state_name)
