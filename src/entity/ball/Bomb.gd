extends Ball


onready var label = $Label


func set_time(seconds):
	label.text = str("%02d" % seconds)
