extends Node2D


onready var animation = $AnimationPlayer
onready var first_button = $CanvasLayer/Menu/Buttons/NormalMode

var gamemode_paths = {
	Enums.Gamemode.NORMAL: "res://src/gamemode/Tennis.tscn",
	Enums.Gamemode.HOTPOTATO: "",
	Enums.Gamemode.BOTTLE: "",
}
var selected_gamemode_path = gamemode_paths[Enums.Gamemode.NORMAL]


func _ready():
	# TODO: better layout for start screen
	animation.play("enter")


func start_exit_sequence(gamemode):
	var path = gamemode_paths[gamemode]
	if not len(path) > 0:
		return
	
	selected_gamemode_path = path
	animation.play("exit")


func finish_exit_sequence():
	var _ok = get_tree().change_scene(selected_gamemode_path)


func _on_NormalMode_button_up():
	start_exit_sequence(Enums.Gamemode.NORMAL)


func _on_HotPotato_button_up():
	start_exit_sequence(Enums.Gamemode.HOTPOTATO)


func _on_BottleTennis_button_up():
	start_exit_sequence(Enums.Gamemode.BOTTLE)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "enter":
		first_button.grab_focus()
	if anim_name == "exit":
		finish_exit_sequence()
