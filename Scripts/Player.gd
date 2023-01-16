extends KinematicBody2D

onready var sprite = get_node("AnimatedSprite")
var velocity = Vector2()
onready var collision_area_for_enemies:Area2D = get_node("CollisionWithEnemies")
onready var dagger_scene = preload("res://Scenes/Dagger.tscn")

var movement_speed = 250
var attack_damage = 10
var crit_chance = 0.02
var crit_dmg = 1.2
var level = 0
var health = 100
var invincibility_time_left = 0
var max_invincibility_time = 0.5
var animation_player_lock = false

var attack_speed = 50
var time_since_last_attack = 0
var hit_direction = 'east'

onready var current_equipped_weapon = dagger_scene

func _move(delta):
	if animation_player_lock:
		return

	velocity = Vector2()
	if Input.is_action_pressed('right'):
		velocity.x += 1
		sprite.flip_h = false
		hit_direction = 'east'
	if Input.is_action_pressed('left'):
		velocity.x -= 1
		sprite.flip_h = true
		hit_direction = 'west'
	if Input.is_action_pressed('down'):
		velocity.y += 1
		hit_direction = 'south'
	if Input.is_action_pressed('up'):
		velocity.y -= 1
		hit_direction = 'north'
	velocity = velocity.normalized() * movement_speed
	
	if velocity:
		sprite.play("walk")
	else:
		sprite.play("default")
	move_and_slide(velocity)


func _die():
	sprite.play('death')
	set_physics_process(false)
	
func take_dmg(amount):
	if invincibility_time_left >0:
		return
	invincibility_time_left = max_invincibility_time
	
	sprite.play("hurt")
	health -= amount
	animation_player_lock = true
	
	if health <= 0:
		_die()

func attack(delta):
	time_since_last_attack += delta
	var time_between_attacks = 60/attack_speed
	
	if time_since_last_attack >= time_between_attacks:
		print('attacked')
		var weapon_instance = current_equipped_weapon.instance()
		
		sprite.play("attack")
		var current_dmg = attack_damage
		
		# check for crit
		if randf() < crit_chance:
			current_dmg = attack_damage*crit_dmg
		
		weapon_instance.attack(current_dmg, self, hit_direction)
		add_child(weapon_instance)
		time_since_last_attack = 0
		
	
func _ready():
	sprite.play("default")
	Signalbus.connect("enemy_spawn", self, "set_player_reference")

func set_player_reference():
	Signalbus.emit_signal("send_player_reference", self)

func _physics_process(delta):
	attack(delta)
	invincibility_time_left -= delta
	_move(delta)

	for enemy in collision_area_for_enemies.get_overlapping_bodies():
		take_dmg(enemy.attack)


func _on_CollisionWithEnemies_area_entered(area):
	pass # Replace with function body.


func _on_AnimatedSprite_animation_finished():
	animation_player_lock = false
	if sprite.animation == "death":
		Signalbus.emit_signal("player_died", self)
