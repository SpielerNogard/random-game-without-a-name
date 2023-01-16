extends Node2D

onready var my_sprite = get_node("Sprite")
onready var attack_area = get_node("Area2D/CollisionShape2D")

var speed = 50
var bullet_direction = Vector2(1,0)
var flying = false
var life_duration = 5

func attack(dmg, player, direction):
	flying = true
	if not attack_area:
		attack_area = get_node("Area2D/CollisionShape2D")
	attack_area.disabled = false
	global_position = player.global_position
	
	if direction == 'east':
		bullet_direction = Vector2(1,0)
	if direction == 'west':
		bullet_direction = Vector2(-1, 0)
	if direction == 'north':
		bullet_direction = Vector2(0,-1)
	if direction == 'south':
		bullet_direction = Vector2(0,1)
	
func _physics_process(delta):
	
	if flying and life_duration >= 0:
		global_position += bullet_direction * speed * delta
		life_duration -= delta
		rotation_degrees += 300*life_duration*delta
		
	if life_duration <=0:
		queue_free()
		
func _on_Area2D_body_entered(body):
	print(body)
	if body.is_in_group('enemies'):
		pass
