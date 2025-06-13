extends CharacterBody2D

var speed = 55
var player_chase = false
var player: Player = null

var health = 100
var player_in_attack_zone = false
var can_take_damage = true

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var healthbar: ProgressBar = $healthbar
@onready var take_damage_cooldown: Timer = $take_damage_cooldown
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _physics_process(delta):
	if player_chase and is_instance_valid(player):
		position += (player.position - position)/ speed
		animated_sprite.play("walk")
		if(player.position.x - position.x) < 0:
			animated_sprite.flip_h = true
		else:
			animated_sprite.flip_h = false
	else:
		animated_sprite.play("idle")
	deal_with_damage()
	update_health()
	move_and_slide()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
		player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player = null
		player_chase = false

func enemy():
	pass

func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_attack_zone = true

func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_attack_zone = false

func deal_with_damage():
	if player_in_attack_zone and global.player_current_attack and can_take_damage:
		health -= global.AtackDamage
		can_take_damage = false
		take_damage_cooldown.start()
		print("INIMIGO: Vida restante = ", health)
		
		if health <= 0:
			die()

func die():
	set_physics_process(false)
	collision_shape.set_deferred("disabled", true)
	
	animated_sprite.play("death")
	
	await animated_sprite.animation_finished
	
	queue_free()


func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true

func update_health():
	healthbar.value = health
	
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true
