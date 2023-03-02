extends Node2D


onready var first_button = $CanvasLayer/Menu/NormalMode
onready var animation = $AnimationPlayer

var gamemode_paths = {
	Enums.Gamemode.NORMAL: "res://src/gamemode/Tennis.tscn",
	Enums.Gamemode.HOTPOTATO: "",
	Enums.Gamemode.BOTTLE: "",
	Enums.Gamemode.TRAINING: ""
}
var selected_gamemode_path = gamemode_paths[Enums.Gamemode.NORMAL]
var waiting_starting_input = false


func _ready():
	waiting_starting_input = false
	animation.play("start")


func _unhandled_input(event):
	if not waiting_starting_input: return
	if event is InputEventMouseMotion: return
	waiting_starting_input = false
	animation.play("showSelection")


func start_exit_sequence(gamemode):
	var path = gamemode_paths[gamemode]
	if not len(path) > 0:
		return
	
	selected_gamemode_path = path
	# TODO: animation
	finish_exit_sequence()


func finish_exit_sequence():
	var _ok = get_tree().change_scene(selected_gamemode_path)


func _on_NormalMode_button_up():
	start_exit_sequence(Enums.Gamemode.NORMAL)


func _on_HotPotato_button_up():
	start_exit_sequence(Enums.Gamemode.HOTPOTATO)


func _on_BottleTennis_button_up():
	start_exit_sequence(Enums.Gamemode.BOTTLE)


func _on_TrainingMode_button_up():
	start_exit_sequence(Enums.Gamemode.TRAINING)


func _on_OptionsButton_button_up():
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "start":
		waiting_starting_input = true
	
	if anim_name == "showSelection":
		waiting_starting_input = false
		first_button.grab_focus()
