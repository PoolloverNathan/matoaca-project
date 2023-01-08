class_name Savegame extends Node
export var spawn_at := Vector2(112, -360)
export var current_stage := 1
export var started_at: int = OS.get_unix_time()

## Unobtainable gem in stage 1, surrounded by lasers.
export var stage_1_green = false
export var stage_1_no_lasers = false
