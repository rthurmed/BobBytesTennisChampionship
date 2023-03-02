extends RigidBody2D
class_name Ball


const COLLISION_ENABLED = 4
const COLLISION_DISABLED = 1

signal touched_floor


func set_collision(enabled):
	collision_layer = COLLISION_ENABLED if enabled else COLLISION_DISABLED


func _on_Ball_body_entered(body):
	if body.is_in_group('floor'):
		emit_signal("touched_floor")
