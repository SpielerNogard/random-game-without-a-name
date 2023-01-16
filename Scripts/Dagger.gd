extends Weapon

onready var my_sprite = get_node("Sprite")
onready var attack_area = get_node("Area2D/CollisionShape2D")

var speed = 50
var bullet_direction = Vector2(1,0)
var flying = false
var max_life_duration = 5
var life_duration = 0
var dagger_dmg = 0

func _attack(player):
	life_duration = max_life_duration
	flying = true
	if not attack_area:
		attack_area = get_node("Area2D/CollisionShape2D")
	attack_area.disabled = false
	position = player.position
	dagger_dmg = player.dmg
	var direction = player.hit_direction
	print(dagger_dmg)
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
		attack_area.disabled = true
		visible = false
		flying = false
		
func _on_Area2D_body_entered(body):
	body.get_damage(dagger_dmg)
