extends Node
signal save_loaded(savegame, new)
var _savegame: Savegame = null
export var saveFile = "user://save.tscn"
const green = ["gem_green_l1"]
const orange = []

func getOrangeGemCount():
	var total = 0
	var has = 0
	for key in orange:
		total += 1
		if _savegame.get(key):
			has += 1
	return [has, total]
func getGreenGemCount():
	var total = 0
	var has = 0
	for key in green:
		total += 1
		if _savegame.get(key):
			has += 1
	return [has, total]

func _ready():
	loadSave()

func getSave():
	return _savegame
func resetSave():
	_savegame = Savegame.new()
func save():
	var pscn := PackedScene.new()
	pscn.pack(_savegame)
	ResourceSaver.save("user://save.tscn", pscn)
func loadSave():
	if ResourceLoader.exists("user://save.tscn"):
		_savegame = load("user://save.tscn").instance()
		emit_signal("save_loaded", _savegame, false)
	else:
		_savegame = Savegame.new()
		emit_signal("save_loaded", _savegame, true)

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
