extends State

const MOVE_SPEED = 50
const ATTACK_ANGLE = deg2rad(45)


func process(delta: float):
	owner.move(delta, owner.grab_movement() * MOVE_SPEED)


func enter():
	owner.animation.play("Attack")


func _on_AttackArea2D_body_entered(body):
	if not active():
		return
	
	var strength = 200 # TODO: make it variable
	var horizontal_modifier = 1 if owner.opposite_side else -1
	var direction = Vector2.LEFT
	direction = direction.rotated(ATTACK_ANGLE)
	direction.x = direction.x * horizontal_modifier
	
	body.set_deferred("linear_velocity", Vector2.ZERO)
	body.call_deferred("apply_central_impulse", direction * strength)


func _on_AnimationPlayer_animation_finished(anim_name):
	if not active():
		return
	
	if not anim_name == "Attack":
		return
	
	transition("Idle")
