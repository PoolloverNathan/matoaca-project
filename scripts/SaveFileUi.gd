tool extends PanelContainer
export var filenum = 0
var file: String
var erased = false
var _File = File.new()
var _Directory = Directory.new()
onready var header := $Box/Header
onready var contents := $Box/Contents
onready var copy := $Box/Buttons/CopyButton
onready var delete :=  $Box/Buttons/DeleteButton
onready var play := $Box/Buttons/PlayButton

func _process(_delta):
	file = "user://save_%s.tscn" % filenum
	header.text = "File " + str(filenum)
	if _File.file_exists(file):
		var scn = load(file)
		var green = PlayerService.getGreenGemCount(scn)
		var orange = PlayerService.getOrangeGemCount(scn)
		contents.text = """
		a
		b
		c
		"""
		setText("Resume", "", "Erase")
	else:
		contents.text = "Slot erased." if erased else "This slot is empty."
		setText("Start", "", "")


func _protected(_value):
	assert(false, "Cannot set read-only property")
func setText(_play, _copy, _delete):
	setTextFor(play, _play)
	setTextFor(copy, _copy)
	setTextFor(delete, _delete)
func setTextFor(button, text):
	if text == "":
		button.hide()
	else:
		button.show()
		button.text = text

func _run():
	request_ready()

func _on_PlayButton_pressed():
	print("loading file %d at %s" % [filenum, file])
	PlayerService.saveFile = file
	PlayerService.loadSave()
	PlayerService.pushScene(load(PlayerService.getSave().level))
	PlayerService.save(true)
	print("loaded scene %s" % PlayerService.getSave().level)


func _on_DeleteButton_pressed():
	_Directory.remove(file)
	erased = true
