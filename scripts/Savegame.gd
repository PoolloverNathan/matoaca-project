class_name Savegame extends Node
export var spawn_at := Vector2(24, -520)
export var level := "res://levels/level2.tscn"
export var current_stage := 1
export var started_at: int = OS.get_unix_time()

export var stage_1_checkpoint = false
export var stage_1_no_lasers = false
