extends State


func process(delta: float):
	if (
		Input.is_action_just_pressed(owner.get_action("left")) or
		Input.is_action_just_pressed(owner.get_action("right"))
	):
		transition("Walk")
		return
	
	if not owner.ground_raycast.is_colliding():
		transition("Fall")
		return
	
	owner.move(delta, Vector2.ZERO)


func physics_process(_delta: float): pass
func enter(): pass
func exit(): pass
