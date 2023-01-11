tool extends EditorScript

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.s
func _run():
	var nodes = []
	for on in get_editor_interface().get_selection().get_selected_nodes():
		var nn = Node.new()
		on.add_child(nn)
		nn.owner = on.owner
		nodes.push_back(nn)
	get_editor_interface().get_selection().clear()
	for n in nodes:
		get_editor_interface().get_selection().add_node(n)                   


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
