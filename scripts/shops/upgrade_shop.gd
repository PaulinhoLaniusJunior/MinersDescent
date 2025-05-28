extends CharacterBody2D

func _ready() -> void:
	$Area2D/ShopScene/CanvasLayer.visible = false
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player_shop_method"):
		$Area2D/ShopScene/CanvasLayer.visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	$Area2D/ShopScene/CanvasLayer.visible = false
