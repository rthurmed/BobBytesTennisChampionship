extends State


onready var animation = $AnimationPlayer
onready var gameover_title = $Overlay/Gameover/Title

var showed_message = false


func process(_delta: float):
	if not showed_message: return
	if Input.is_action_just_released("reset"):
		var _ok = get_tree().reload_current_scene()


func enter():
	showed_message = false
	
	owner.ball.set_collision(false)
	
	var tie = owner.points_char1 == owner.points_char2
	
	if tie:
		gameover_title.text = str("TIE!")
	
	if not tie:
		var char1_won = owner.points_char1 > owner.points_char2
		var winner = "PLAYER 1" if char1_won else "PLAYER 2"
		gameover_title.text = str(winner, " WON!")
	
	owner.sound_win.play()
	
	animation.play("gameover")


func _on_AnimationPlayer_animation_finished(anim_name):
	if not active(): return
	if not anim_name == "gameover": return
	showed_message = true
