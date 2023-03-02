extends CanvasLayer


func _on_BackButton_button_up():
	var _ok = get_tree().change_scene("res://src/GamemodeSelect.tscn")
