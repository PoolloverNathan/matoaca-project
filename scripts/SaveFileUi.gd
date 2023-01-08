tool extends PanelContainer
export var filenum = 0
var _File = File.new()

func _process(_delta):
	var file = "user://save_%s.tscn"
	$Control/Header.text = "File " + str(filenum)
	if _File.file_exists(file):
		var scn = load("user://save_%s.tscn" % str(filenum))
		var green = PlayerService.getGreenGemCount(scn)
		var orange = PlayerService.getOrangeGemCount(scn)
		$Control/Label.text = """
		a
		b
		c
		"""
	else:
		$Control/Label.text = ""

func _protected(_value):
	assert(false, "Cannot set read-only property")
