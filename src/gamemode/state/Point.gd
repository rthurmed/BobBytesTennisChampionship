extends State


onready var reset_timer = $Reset

var point_by = Enums.BallHolder.Player1


func handle_input(_event: InputEvent): pass
func process(_delta: float): pass
func physics_process(_delta: float): pass


func enter():
	point_by = opposite_holder(owner.ball.holder)
	
	owner.highlight.stop()
	owner.ball.set_collision(false)
	
	if point_by == Enums.BallHolder.Player1:
		owner.points_char1 += 1
	else:
		owner.points_char2 += 1
	
	owner.update_displays()
	
	# is the last point?
	if (
		owner.points_char1 >= owner.points_to_win or
		owner.points_char2 >= owner.points_to_win
	):
		transition("Gameover")
		return
	
	owner.sound_score.play()
	reset_timer.start()


func exit():
	owner.ball.set_collision(true)


func opposite_holder(holder):
	if holder == Enums.BallHolder.Player1: return Enums.BallHolder.Player2
	if holder == Enums.BallHolder.Player2: return Enums.BallHolder.Player1


func _on_Reset_timeout():
	if not active(): return
	
	# reset ball
	owner.ball.queue_free()
	owner.next_holder = point_by
	
	transition("Playing")
