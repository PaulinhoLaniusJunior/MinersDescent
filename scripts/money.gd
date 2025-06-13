extends Control

@onready var money_label: RichTextLabel = $RichTextLabel

func _physics_process(delta: float) -> void:
	money_label.text = format_number(global.money)


func format_number(number: float) -> String:
	if number < 100000:
		return str(int(round(number)))

	var divisor: float
	var suffix: String

	if number >= 1_000_000_000_000:
		divisor = 1_000_000_000_000.0
		suffix = "T"
	elif number >= 1_000_000_000:
		divisor = 1_000_000_000.0
		suffix = "B"
	elif number >= 1_000_000:
		divisor = 1_000_000.0
		suffix = "M"
	else:
		divisor = 1_000.0
		suffix = "K"
	
	var value = number / divisor
	var decimal_places = 0
	
	if value < 10:
		decimal_places = 4
	elif value < 100:
		decimal_places = 3
	elif value < 1000:
		decimal_places = 2

	var format_string = "%.{dp}f".format({"dp": decimal_places})
	var formatted_value_str = format_string % value

	return formatted_value_str + suffix
