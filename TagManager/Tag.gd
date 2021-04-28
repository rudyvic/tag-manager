extends VBoxContainer

signal tag_selected

onready var btn = $Button
onready var lbl = $Label
var _tag: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_tag(tag: String):
	_tag = tag
	btn.text = _tag

func get_tag() -> String:
	return _tag

func _on_Button_pressed():
	emit_signal("tag_selected",_tag)
