extends CharacterBody2D

var player = null
var bonusMoney = 50000
var health = 100000
var player_inattack_zone = false
var can_take_damage = true

@onready var hit_sound_player: AudioStreamPlayer = $HitSoundPlayer

func _physics_process(delta):
	deal_with_damage()
	update_health()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player = null

func stone():
	pass


func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:
		player_inattack_zone = true


func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body is Player:
		player_inattack_zone = false

func deal_with_damage():
	if player_inattack_zone and global.player_current_mining == true:
		if can_take_damage == true:
			if is_instance_valid(hit_sound_player):
				hit_sound_player.play()
			health = health - global.MinerDamage
			global.money += global.MinerDamage
			print(global.money)
			$take_damage_cooldown.start()
			can_take_damage = false
			print("stone = ", health)
			if health <= 0:
				global.money += bonusMoney
				self.queue_free()


func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true

func update_health():
	var healthbar = $healthbar
	
	healthbar.value = health
	if health >= 100000:
		healthbar.visible = false
	else:
		healthbar.visible = true
