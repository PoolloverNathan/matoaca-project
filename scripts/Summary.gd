extends Label
var template = text
onready var _file: File = File.new()
onready var _time: Time = Time.new()

func _process(delta):
	var green = PlayerService.getGreenGemCount()
	var orange = PlayerService.getOrangeGemCount()
	var mtime = timeify(_file.get_modified_time("user://save.tscn")) if _file.file_exists("user://save.tscn") else 0
	text = template
	text = text.replace("{{time}}", timeify(mtime))
	text = text.replace("{{O}}", orange[0])
	text = text.replace("{{OMAX}}", orange[1])
	text = text.replace("{{G}}", green[0])
	text = text.replace("{{GMAX}}", green[1])
	text = text.replace("{{Difficulty}}", PlayerService.diffcultyString())

func timeify(unix):
	if unix == 0: return "never"
	var time = _time.get_date_dict_from_unix_time(unix)
	return ", ".join(time.keys())
