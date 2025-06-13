extends Area2D

@export var next_level : String = ""
@export var required_key_flag: String = ""
@export var transition_controller : CanvasLayer

@export var feedback_label: Label

var is_showing_message = false

@onready var transition_animator := transition_controller.get_node("AnimationPlayer")


func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	if is_instance_valid(feedback_label):
		feedback_label.visible = false

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		
		# --- Verificação da Chave ---
		if not required_key_flag.is_empty():
			var key_value = global.get(required_key_flag)
			var player_has_key = false

			if key_value == null:
				printerr("DOOR: A propriedade/flag de chave '%s' não foi encontrada em global.gd ou é nula." % required_key_flag)
				return
			elif typeof(key_value) == TYPE_BOOL:
				player_has_key = key_value
			else:
				printerr("DOOR: A propriedade/flag de chave '%s' em global.gd não é do tipo Booleano!" % required_key_flag)
				return
			
			# --- Lógica de Feedback ---
			if not player_has_key:
				if is_showing_message:
					return
				
				if is_instance_valid(feedback_label):
					is_showing_message = true
					feedback_label.text = "Porta Trancada! Compre a chave para entrar."
					feedback_label.visible = true
					
					await get_tree().create_timer(3.0).timeout
					
					feedback_label.visible = false
					is_showing_message = false
				else:
					print("Porta trancada! Requer a flag de chave: ", required_key_flag)
				
				return
		
		# --- Lógica de Transição (se o jogador tiver a chave) ---
		transition_animator.play("fade_in")
		await transition_animator.animation_finished
		
		var parent_level_node = get_parent()
		if is_instance_valid(parent_level_node):
			global.destination_level = parent_level_node.name
		else:
			printerr("DOOR: Não foi possível obter o nó pai para definir destination_level.")
			global.destination_level = ""

		get_tree().call_deferred("change_scene_to_file", next_level)
