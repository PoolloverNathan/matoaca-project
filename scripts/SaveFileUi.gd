tool extends Button
export var filenum = 0
var _File = File.new()
onready var header := $Panel/Box/Header
onready var contents := $Panel/Box/Contents
onready var buttons := $Panel/Box/Buttons

func _process(_delta):
	var file = "user://save_%s.tscn"
	header.text = "File " + str(filenum)
	if _File.file_exists(file):
		var scn = load("user://save_%s.tscn" % str(filenum))
		var green = PlayerService.getGreenGemCount(scn)
		var orange = PlayerService.getOrangeGemCount(scn)
		contents.text = """
		a
		b
		c
		"""
	else:
		contents.text = "This slot is empty."
		buttons.get_no
		

func _protected(_value):
	assert(false, "Cannot set read-only property")
