tool extends HBoxContainer

export var INPUT_NAME := ""
export(Array, int) var KEYBIND_BLACKLIST: Array = [KEY_ESCAPE, KEY_CONTROL, KEY_ALT, KEY_SHIFT, KEY_SUPER_L, KEY_SUPER_R, KEY_META, KEY_SYSREQ, KEY_STOP, KEY_META]
onready var obut = $OptionButton

func update():
	$Name.text = INPUT_NAME
	$Value.text = OS.get_scancode_string(PlayerService.getPrefs().get(INPUT_NAME))

func _ready():
	update()
func _input(event):
	if $SetButton.pressed and event is InputEventKey:
		if not KEYBIND_BLACKLIST.has(event.scancode):
			PlayerService.getPrefs()[INPUT_NAME] = event.scancode
			PlayerService.bind_key(INPUT_NAME, event)
			$SetButton.pressed = false
	update()
