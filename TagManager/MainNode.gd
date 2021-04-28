extends CanvasLayer

onready var textEdit = $VBoxContainer/TextEdit
var file_name : String = ""
var Tag = preload("res://Tag.tscn")

var _tags = ["introduzione", "descrizione", "conclusione"]

# Called when the node enters the scene tree for the first time.
func _ready():
	for t in _tags:
		var tag = Tag.instance()
		$VBoxContainer/HBoxContainer.add_child(tag)
		tag.set_tag(t)
		tag.connect("tag_selected",textEdit,"_on_btnHighlight_pressed")
	textEdit.set_tags(_tags)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _save():
	var file = File.new()
	file.open(file_name, File.WRITE)
	file.store_string(textEdit.text)
	file.close()


func _on_btnSave_pressed():
	_save()


func _on_btnSaveAs_pressed():
	$FileDialogSave.invalidate()
	$FileDialogSave.popup()


func _on_btnLoad_pressed():
	$FileDialogLoad.invalidate()
	$FileDialogLoad.popup()


func _on_FileDialogSave_file_selected(path):
	file_name = path
	$VBoxContainer/HBoxContainer/btnSave.disabled = false
	_save()


func _on_FileDialogLoad_file_selected(path: String):
	var file_to_str = ""
	var file = File.new()
	file.open(path, File.READ)
	while not file.eof_reached():
		var line = file.get_line()
		file_to_str += line + "\n"
	file.close()
	textEdit.text = file_to_str



func _on_btnRemoveTag_pressed():
	textEdit.remove_selected_tag()


func _on_TextEdit_cursor_changed():
	$VBoxContainer/HBoxContainer/btnRemoveTag.disabled = !textEdit._is_in_tag_cursor()
