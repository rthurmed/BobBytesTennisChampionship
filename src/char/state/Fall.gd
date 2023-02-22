extends State


const SPEED = 100


func process(delta: float):
	if owner.ground_raycast.is_colliding():
		transition("Walk")
		return
	
	owner.move(delta, owner.with_gravity(owner.grab_movement() * SPEED))


func physics_process(_delta: float): pass
func enter(): pass
func exit(): pass
