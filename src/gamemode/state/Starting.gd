extends State


func handle_input(_event: InputEvent): pass
func process(_delta: float): pass
func physics_process(_delta: float): pass


func enter():
	# TODO
	owner.points_char1 = 0
	owner.points_char2 = 0
	owner.time_of_play = 0
	owner.update_displays()
	transition("Playing")


func exit(): pass
