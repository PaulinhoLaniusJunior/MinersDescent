extends Control

var player = null

func _physics_process(delta: float) -> void:
	if player and is_instance_valid(player):
		$RichTextLabel.text = "= " + str(player.money)
	else:
		$RichTextLabel.text = "= 0"

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
