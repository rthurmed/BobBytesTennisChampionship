extends State


const SPEED = 100


func process(delta: float):
	if (
		not Input.is_action_pressed(owner.get_action("left")) and
		not Input.is_action_pressed(owner.get_action("right"))
	):
		transition("Idle")
		return
	
	if Input.is_action_just_pressed(owner.get_action("attack")):
		transition("HoldAttack")
		return
	
	if not owner.ground_raycast.is_colliding():
		transition("Fall")
		return
	
	owner.move(delta, owner.grab_movement() * SPEED)


func physics_process(_delta: float): pass


func enter():
	owner.animation.play("Walk")


func exit():
	owner.animation.play("RESET")
