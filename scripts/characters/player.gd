extends CharacterBody2D
class_name Player

@export var lobby_scene_path: String = "res://scenes/worlds/lobby.tscn"

#skills
var enemy_inattack_range = false
var enemy_attack_cooldown = true
var current_dir = "down"
var mining_ip = false
var attack_ip = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var healthbar: ProgressBar = $healthbar
@onready var death_sound_player: AudioStreamPlayer = $DeathSoundPlayer
@onready var attack_sound_player: AudioStreamPlayer = $AttackSoundPlayer


func _ready():
	animated_sprite.play("front_idle")
	update_healthbar_setup()


func _physics_process(delta):
	if global.health <= 0 and global.player_alive:
		die()
		return 
	
	player_moviment(delta)
	attack()
	mining()
	enemy_attack()
	update_health()


func die():
	global.player_alive = false 
	set_physics_process(false)


	match current_dir:
		"up":
			animated_sprite.flip_h = false
			animated_sprite.play("back_death")
		"down":
			animated_sprite.flip_h = false
			animated_sprite.play("front_death")
		"left":
			animated_sprite.flip_h = true
			animated_sprite.play("side_death")
		"right":
			animated_sprite.flip_h = false
			animated_sprite.play("side_death")
		_:
			animated_sprite.play("front_death")

	if is_instance_valid(death_sound_player):
		death_sound_player.play()
		await death_sound_player.finished
	else:
		await get_tree().create_timer(1.5).timeout

	if global.has_method("get_max_health"):
		global.health = global.get_max_health()
	else:
		global.health = 200

	if lobby_scene_path.is_empty():
		printerr("Caminho para a cena do lobby não definido no Inspector do Player!")
		get_tree().reload_current_scene()
	else:
		get_tree().change_scene_to_file(lobby_scene_path)


func player_moviment(delta):
	if mining_ip or attack_ip:
		velocity = Vector2.ZERO
		play_anim(0)
		return
		
	var new_velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		new_velocity.x = global.speed
	elif Input.is_action_pressed("ui_left"):
		play_anim(1)
		current_dir = "left"
		new_velocity.x = -global.speed
	elif Input.is_action_pressed("ui_down"):
		play_anim(1)
		current_dir = "down"
		new_velocity.y = global.speed
	elif Input.is_action_pressed("ui_up"):
		play_anim(1)
		current_dir = "up"
		new_velocity.y = -global.speed
	else:
		play_anim(0)
	
	velocity = new_velocity
	move_and_slide()


func play_anim(movement):
	if mining_ip or attack_ip:
		return
		
	var dir = current_dir
	if dir == "right":
		animated_sprite.flip_h = false
		if movement == 1: animated_sprite.play("side_walk")
		else: animated_sprite.play("side_idle")
	elif dir == "left":
		animated_sprite.flip_h = true
		if movement == 1: animated_sprite.play("side_walk")
		else: animated_sprite.play("side_idle")
	elif dir == "down":
		animated_sprite.flip_h = false
		if movement == 1: animated_sprite.play("front_walk")
		else: animated_sprite.play("front_idle")
	elif dir == "up":
		animated_sprite.flip_h = false 
		if movement == 1: animated_sprite.play("back_walk")
		else: animated_sprite.play("back_idle")


func mining():
	if Input.is_action_just_pressed("mining") and not mining_ip:
		global.player_current_mining = true
		mining_ip = true
		
		var dir = current_dir
		if dir == "up": animated_sprite.play("mining_back")
		elif dir == "down": animated_sprite.play("front_mining")
		else: 
			if dir == "left": animated_sprite.flip_h = true
			else: animated_sprite.flip_h = false
			animated_sprite.play("mining")
		$deal_miner_time.start()


func _on_deal_miner_time_timeout() -> void:
	$deal_miner_time.stop()
	global.player_current_mining = false
	mining_ip = false


func attack():
	if Input.is_action_just_pressed("attack") and not attack_ip:
		global.player_current_attack = true
		attack_ip = true
		
		if is_instance_valid(attack_sound_player):
			attack_sound_player.play()

		var dir = current_dir
		if dir == "up": animated_sprite.play("back_attack")
		elif dir == "down": animated_sprite.play("front_attack")
		else:
			if dir == "left": animated_sprite.flip_h = true
			else: animated_sprite.flip_h = false
			animated_sprite.play("side_attack")
		$deal_attack_timer.start()


func _on_deal_attack_timer_timeout() -> void:
	$deal_attack_timer.stop()
	global.player_current_attack = false
	attack_ip = false


func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = true


func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = false


func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown:
		global.health -= 20 
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print("Player tomou dano! Vida = ", global.health)


func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true


func update_healthbar_setup():
	if global.has_method("get_max_health"):
		healthbar.max_value = global.get_max_health()
	else:
		healthbar.max_value = 200


func update_health():
	healthbar.value = global.health
	
	var current_max_health = healthbar.max_value
	if global.health >= current_max_health:
		healthbar.visible = false
	else:
		healthbar.visible = true


func _on_regin_timer_timeout() -> void:
	var current_max_health = 200
	if global.has_method("get_max_health"):
		current_max_health = global.get_max_health()

	if global.health < current_max_health:
		global.health += 20
		if global.health > current_max_health:
			global.health = current_max_health


func player_shop_method():
	pass
