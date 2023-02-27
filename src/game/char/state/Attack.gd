extends State

const MOVE_SPEED = 30
const ATTACK_ANGLE = deg2rad(40)
const ATTACK_STRENGTH = 200
const ATTACK_MAX_MULTIPLIER = 6 # times the base strength


func process(delta: float):
	owner.move(delta, owner.grab_movement() * MOVE_SPEED)


func enter():
	owner.animation.play("Attack")


func _on_AttackArea2D_body_entered(body):
	if not active():
		return
	
	var strength_modifier = 1 + (owner.attack_strength * ATTACK_MAX_MULTIPLIER)
	var strength = ATTACK_STRENGTH * strength_modifier
	
	owner.attack(body, strength)


func _on_AnimationPlayer_animation_finished(anim_name):
	if not active():
		return
	
	if not anim_name == "Attack":
		return
	
	transition("Idle")
