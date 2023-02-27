extends Node2D


const CAMERA_SHAKE_REFERENCE_POINT = 600

onready var camera_shake = $Camera2D/Shake


func apply_camera_shake(strength):
	var shake_strength = strength / CAMERA_SHAKE_REFERENCE_POINT
	camera_shake.impact(camera_shake.default_time, shake_strength)


func _on_Person_attack_executed(strength):
	apply_camera_shake(strength)
	$Sounds/HitBall.play()
