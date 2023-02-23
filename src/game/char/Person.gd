extends KinematicBody2D


export var opposite_side = false
export var action_prefix = "p1_"
export var default_speed = 200

onready var visual_instance = $VisualInstance
onready var colliders = $Colliders
onready var ground_raycast = $GroundRayCast2D
onready var animation = $AnimationPlayer

var velocity = Vector2.ZERO


func _ready():
	var scale_x = -1 if opposite_side else 1
	visual_instance.scale.x = scale_x
	colliders.scale.x = scale_x


func get_action(action: String):
	return action_prefix + action


func grab_movement() -> Vector2:
	return Vector2.RIGHT * (
		Input.get_action_strength(get_action("right")) - 
		Input.get_action_strength(get_action("left"))
	)


func with_gravity(movement = Vector2.ZERO):
	return movement + Vector2.DOWN * 98


func move(delta, movement = Vector2.ZERO):
	# var _collision = move_and_collide(velocity * delta)
	velocity = lerp(velocity, movement, delta * 8)
	var _slide = move_and_slide(velocity, Vector2.UP)


func _on_StateMachine_transition(state_name):
	print(name + ' changed state to: ' + state_name)
