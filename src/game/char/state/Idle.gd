extends State


func process(delta: float):
	if (
		Input.is_action_pressed(owner.get_action("left")) or
		Input.is_action_pressed(owner.get_action("right"))
	):
		transition("Walk")
		return
	
	if Input.is_action_just_pressed(owner.get_action("attack")):
		transition("HoldAttack")
		return
	
	if not owner.ground_raycast.is_colliding():
		transition("Fall")
		return
	
	owner.move(delta, Vector2.ZERO)


func enter():
	owner.animation.play("Idle")


func exit(): pass
