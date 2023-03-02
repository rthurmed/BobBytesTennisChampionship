extends State


onready var score_char1 = $"../../Layers/Backdrop/ScoreDisplay/LabelChar1"
onready var score_char2 = $"../../Layers/Backdrop/ScoreDisplay/LabelChar2"
onready var reset_timer = $Reset

var point_by = false


func handle_input(_event: InputEvent): pass
func process(_delta: float): pass
func physics_process(_delta: float): pass


func enter():
	point_by = not owner.ball_on_char1
	
	owner.floor_highlight.stop()
	owner.ball.set_collision(false)
	
	if point_by:
		owner.points_char1 += 1
	else:
		owner.points_char2 += 1
	
	update_displays()
	
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


func update_displays():
	$"../../DebugNode/PointsChar1Label".text = 'points char1: ' + str(owner.points_char1)
	$"../../DebugNode/PointsChar2Label".text = 'points char2: ' + str(owner.points_char2)
	
	score_char1.text = str("%02d" % owner.points_char1)
	score_char2.text = str("%02d" % owner.points_char2)


func _on_Reset_timeout():
	if not active(): return
	
	# reset ball
	owner.ball.queue_free()
	owner.ball_on_char1 = point_by
	
	transition("Playing")
