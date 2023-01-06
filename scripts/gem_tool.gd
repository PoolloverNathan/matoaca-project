tool extends Sprite

func _process(_delta):
	modulate = get_parent().get_parent().get_parent().get_color()
