extends Node2D


export var with_timer = true

onready var label1 = $Display/LabelChar1
onready var label2 = $Display/LabelChar2
onready var timer = $Timer
onready var time_label = $Timer/Time


func _ready():
	timer.visible = with_timer


func set_value(node, value):
	node.text = str("%02d" % value)


func set_char1(value):
	set_value(label1, value)


func set_char2(value):
	set_value(label2, value)


func set_time(seconds):
	var time_m = floor(seconds / 60)
	var time_s = int(seconds) % 60
	time_label.text = str("%02d:%02d" % [time_m, time_s])
