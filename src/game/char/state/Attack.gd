extends State

const MOVE_SPEED = 30
const ATTACK_ANGLE = deg2rad(40)
const ATTACK_STRENGTH = 200
const ATTACK_MAX_MULTIPLIER = 4 # times the base strength
const ATTACK_ANGLE_NORMAL = deg2rad(45)
const ATTACK_ANGLE_HIGH = deg2rad(60)
const ATTACK_ANGLE_LOW = deg2rad(30)


func process(delta: float):
	owner.move(delta, owner.grab_movement() * MOVE_SPEED)


func enter():
	owner.animation.play("Attack")


func get_attack_angle():
	# FIXME: hard to intentionally execute a different attack
	var angle = ATTACK_ANGLE_NORMAL
	
	var action_forward = owner.get_action("right")
	var action_backward = owner.get_action("left")
	
	if owner.opposite_side:
		action_forward = owner.get_action("left")
		action_backward = owner.get_action("right")
	
	if Input.is_action_pressed(action_forward):
		angle = ATTACK_ANGLE_LOW
	elif Input.is_action_pressed(action_backward):
		angle = ATTACK_ANGLE_HIGH
	
	return angle


func _on_AttackArea2D_body_entered(body):
	if not active():
		return
	
	var strength_modifier = 1 + (owner.attack_strength * ATTACK_MAX_MULTIPLIER)
	var horizontal_modifier = 1 if owner.opposite_side else -1
	
	var angle = get_attack_angle()
	var strength = ATTACK_STRENGTH * strength_modifier
	var direction = Vector2.LEFT
	
	direction = direction.rotated(angle)
	direction.x = direction.x * horizontal_modifier
	
	$"../../DebugNode/AttackStrengthLabel".text = str("strength: ", strength)
	$"../../DebugNode/AttackAngleLabel".text = str("angle: ", rad2deg(angle), "º")
	
	body.set_deferred("linear_velocity", Vector2.ZERO)
	body.call_deferred("apply_central_impulse", direction * strength)


func _on_AnimationPlayer_animation_finished(anim_name):
	if not active():
		return
	
	if not anim_name == "Attack":
		return
	
	transition("Idle")
