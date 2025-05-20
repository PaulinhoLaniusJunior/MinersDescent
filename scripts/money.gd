extends Control

func _physics_process(delta: float) -> void:
	$RichTextLabel.text = "= " + str(global.money)
