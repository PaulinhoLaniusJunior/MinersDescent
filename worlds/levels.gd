extends Node2D

@onready var player: Player = $player

func _ready() -> void:
	if global.destination_level != "":
		var point = get_node(global.destination_level)
		if point:
			player.global_position = point.global_position
