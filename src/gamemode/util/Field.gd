extends Node2D


const TARGET_GROUP = 'ball'

signal changed_field(ball)

onready var ball_start1 = $Positions/BallStart/Char1
onready var ball_start2 = $Positions/BallStart/Char2


func when_body_enter_area(body, holder):
	if not body.is_in_group(TARGET_GROUP): return
	body.holder = holder
	emit_signal("changed_field", body)


func _on_AreaField1_body_entered(body):
	return when_body_enter_area(body, Enums.BallHolder.Player1)


func _on_AreaField2_body_entered(body):
	return when_body_enter_area(body, Enums.BallHolder.Player2)
