tool
extends EditorScript


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _run():
	var sel = get_editor_interface().get_selection()
	var st = sel.get_selected_nodes()[0].get_tree()
	sel.clear()
	sel.add_node(st)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
