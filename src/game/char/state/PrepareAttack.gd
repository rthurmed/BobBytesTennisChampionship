extends State


const SPEED = 120

onready var timer: Timer = $Timer


func process(delta: float):
	if Input.is_action_just_released(owner.get_action("attack")):
		transition("Attack")
	
	owner.move(delta, owner.grab_movement() * SPEED)


func enter():
	owner.animation.play("HoldAttack")
	timer.start()


func exit():
	owner.attack_strength = Util.timer_percent(timer)
