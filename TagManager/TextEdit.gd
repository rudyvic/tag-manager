extends TextEdit

var _tags = []
var _colors = [Color.red, Color.blue, Color.green, Color.pink, Color.aqua]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

func set_tags(tags: Array):
	_tags.clear()
	clear_colors()
	var i = 0
	for t in tags:
		_tags.append(t)
		add_color_region("<"+t+">","</"+t+">",_colors[i%_colors.size()])
		i += 1

func _on_TextEdit_text_changed():
	var tags = {_tags[0]: 0, _tags[1]: 0}
	for r in _take_all_tags(_tags[0]):
		r = r.replace(" ","")
		tags[_tags[0]] += r.length()
	for r in _take_all_tags(_tags[1]):
		r = r.replace(" ","")
		tags[_tags[1]] += r.length()
	var sum = tags[_tags[0]] + tags[_tags[1]]
	if sum == 0:
		return
	get_parent().get_child(1).get_child(0).get_child(1).text = str(100.0 * tags[_tags[0]] / sum, "%")
	get_parent().get_child(1).get_child(1).get_child(1).text = str(100.0 * tags[_tags[1]] / sum, "%")

func _on_TextEdit_cursor_changed():
	print(_is_in_tag_cursor())

func _on_btnHighlight_pressed(extra_arg_0):
	if !is_selection_active():
		return
	var column = cursor_get_column()
	var line = cursor_get_line()
	var line_begin = get_selection_from_line()
	var column_begin = get_selection_from_column()
	var line_end = get_selection_to_line()
	var column_end = get_selection_to_column()
	print("c:",column,",l:",line)
	print("cb:",column_begin,",lb:",line_begin)
	print("ce:",column_end,",le:",line_end)
	deselect()
	cursor_set_line(line_end)
	cursor_set_column(column_end)
	insert_text_at_cursor("</"+extra_arg_0+">")
	cursor_set_line(line_begin)
	cursor_set_column(column_begin)
	insert_text_at_cursor("<"+extra_arg_0+">")
	cursor_set_line(line)
	cursor_set_column(column)
#	var string = get_selection_text()
#	cut()
#	insert_text_at_cursor("<"+extra_arg_0+">"+string+"</"+extra_arg_0+">")

func _is_in_tag_cursor() -> bool:
	if is_selection_active():
		return false
	var column = cursor_get_column()
	var line = cursor_get_line()
	print(column," ",line)
	select(0,0,line,column)
	var temp = get_selection_text()
	deselect()
	cursor_set_line(line)
	cursor_set_column(column)
	
	var i = temp.find_last("<"+_tags[0]+">")
	if i>0:
		temp = temp.right(i+3)
		i = temp.find("</"+_tags[0]+">")
		if i>0:
			return false
		else:
			return true
	return false

func _is_in_tag() -> bool:
	var column = cursor_get_column()
	var line = cursor_get_line()
	
	var line_begin = -1
	var column_begin = -1
	var line_end = line
	var column_end = column
	
	if is_selection_active():
		line_begin = get_selection_from_line()
		column_begin = get_selection_from_column()
		line_end = get_selection_to_line()
		column_end = get_selection_to_column()
	
	select(0,0,line,column)
	var temp = get_selection_text()
	deselect()
	cursor_set_column(column)
	cursor_set_line(line)
	if line_begin != -1:
		select(line_begin,column_begin,line_end,column_end)
	var i = temp.find_last("<"+_tags[0]+">")
	if i>0:
		temp = temp.right(i+3)
		i = temp.find("</"+_tags[0]+">")
		if i>0:
			return false
		else:
			return true
	return false
	
func _take_all_tags(tag: String) -> bool:	
	var regex = RegEx.new()
	regex.compile("<"+tag+">(\\s[^<"+tag+">]*|\\S[^<"+tag+">]*)</"+tag+">")
	var results = []
	for m in regex.search_all(text):
		results.push_back(m.get_string(1))
	return results

func remove_selected_tag():
	print(_take_all_tags(_tags[0]), " ",_take_all_tags(_tags[1]))
	return
	if is_selection_active():
		return false
	var column = cursor_get_column()
	var line = cursor_get_line()
	print(column," ",line)
	select(0,0,line,column)
	var temp = get_selection_text()
	deselect()
	cursor_set_line(line)
	cursor_set_column(column)
	
#	var i = temp.find_last("<A>")
#	if i>0:
#		print("AAA ",temp)
#		temp.erase(i,"<A>".length())
#		temp = temp.right(i+3)
#		i = temp.find("</A>")
#		if i>0:
#			temp.erase(i,"</A>".length())
#
#	print("REMOVED: ",temp)
