tool extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var grid := $Panel/WindowHolder/GridContainer/Grid
var group = ButtonGroup.new()
var PreferenceRow = preload("res://parts/PreferenceRow.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	for name in PlayerService.inputNames:
		var row = PreferenceRow.instance()
		row.INPUT_NAME = name
		row.get_node("SetButton").group = group
		grid.add_child(row)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SaveButton_pressed():
	PlayerService.savePrefs()
	get_tree().change_scene_to(preload("res://start.tscn"))


func _on_ResetButton_pressed():
	PlayerService._prefs = Preferences.new()
