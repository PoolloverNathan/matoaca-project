extends Node
signal save_loaded(savegame, new)
var _savegame: Savegame = Savegame.new()
var _prefs: Preferences = Preferences.new()
export var saveFile = "user://save.tscn"
export var prefsFile = "user://preferences.tscn"
var green = ["stage_1_green"]
var orange = []
var inputNames = ["move_up", "move_left", "move_down", "move_right", "jump"]
export var worthSaving = false
export var active = false

func getOrangeGemCount(save = _savegame):
	var total = 0
	var has = 0
	for key in orange:
		total += 1
		if save.get(key):
			has += 1
	return [has, total]
func getGreenGemCount(save = _savegame):
	var total = 0
	var has = 0
	for key in green:
		total += 1
		if save.get(key):
			has += 1
	return [has, total]

# func _ready():
# 	loadSave()
var jumpEvent
var move_left_event
var move_right_event
var move_up_event
var move_down_event

func getSave():
	return _savegame
func resetSave():
	_savegame = Savegame.new()
func save(force = false):
	if worthSaving or force:
		print("saving" + str(worthSaving) + str(force))
		var pscn := PackedScene.new()
		pscn.pack(_savegame)
		ResourceSaver.save(saveFile, pscn)
		worthSaving = false
func loadSave():
	if ResourceLoader.exists(saveFile):
		_savegame = load(saveFile).instance()
		emit_signal("save_loaded", _savegame, false)
	else:
		_savegame = Savegame.new()
		emit_signal("save_loaded", _savegame, true)
func bind_key(name: String, event: InputEventKey):
	var mkey = name + "_event"
	if get(mkey):
		InputMap.action_erase_event(name, get(mkey))
	set(mkey, event)
	_prefs[name] = event.scancode
	InputMap.action_add_event(name, event)
func load_bound_key(name: String, key: int):
	var evt = InputEventKey.new()
	evt.scancode = key
	bind_key(name, evt)
class SceneEntry:
	var scene: PackedScene
	var user_can_pop = false
	func _init(_scene: PackedScene, _user_can_pop):
		scene = _scene
		user_can_pop = _user_can_pop
onready var scenes: Array = [SceneEntry.new(preload("res://levels/level1.tscn"), false)]
func pushScene(scene: PackedScene, user_can_pop = false, transition = true):
	scenes.push_back(SceneEntry.new(scene, user_can_pop))
	if transition: BlackFade.fadeout()
	get_tree().change_scene_to(scene)
	if transition: BlackFade.fadein()
func popScene(transition = true):
	scenes.pop_back()
	if transition: BlackFade.fadeout()
	get_tree().change_scene_to(scenes.back().scene)
	if transition: BlackFade.fadein()
func canPopScene():
	return scenes.back().user_can_pop
func difficultyString():
	return "Standard"
func savePrefs():
	var pscn := PackedScene.new()
	pscn.pack(_prefs)
	ResourceSaver.save(prefsFile, pscn)
func _init():
	if ResourceLoader.exists(prefsFile):
		_prefs = load(prefsFile).instance()
	else:
		savePrefs()
	for key in inputNames:
		load_bound_key(key, _prefs.get(key))
