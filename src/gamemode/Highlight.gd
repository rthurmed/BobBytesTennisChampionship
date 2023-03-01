extends HBoxContainer


onready var animation = $AnimationPlayer


func stop():
	animation.play("RESET")


func blink(to_char1):
	animation.play("blink_char1" if to_char1 else "blink_char2")
