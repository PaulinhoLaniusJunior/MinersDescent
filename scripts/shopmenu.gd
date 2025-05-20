extends StaticBody2D

var player = null
var priceKey1 = 5000
var priceKey2 = 20000
var priceKey3 = 100000

var comprandochave = 0

func _physics_process(delta):
	if self.visible == true:
		pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body

func buy():
	if comprandochave == 1:
			global.money -= priceKey1
			global.key1 = true
	if comprandochave == 2:
			global.money -= priceKey2
			global.key2 = true
	if comprandochave == 3:
			global.money -= priceKey3
			global.key3 = true


func _on_buy_key_1_pressed() -> void:
	print("botao apertado")
	comprandochave = 1
	if global.money >= priceKey1:
		if global.key1 == false:
			buy()


func _on_buy_key_2_pressed() -> void:
	print("botao 2 apertado")
	comprandochave = 2
	if global.money >= priceKey2:
		if global.key2 == false:
			buy()


func _on_buy_key_3_pressed() -> void:
	print("botao 3 apertado")
	comprandochave = 3
	if global.money >= priceKey3:
		if global.key3 == false:
			buy()
