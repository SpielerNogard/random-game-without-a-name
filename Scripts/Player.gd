extends KinematicBody2D

onready var sprite = get_node("AnimatedSprite")
var velocity = Vector2()


var movement_speed = 250
var attack_speed = 10
var attack_damage = 10
var crit_chance = 0.02
var crit_dmg = 1.2
var level = 0
var health = 10



func _move():
	velocity = Vector2()
	if Input.is_action_pressed('right'):
		velocity.x += 1
		sprite.flip_h = false
	if Input.is_action_pressed('left'):
		velocity.x -= 1
		sprite.flip_h = true
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1
	velocity = velocity.normalized() * movement_speed
	if velocity:
		sprite.play("walk")
	else:
		sprite.play("default")
	move_and_slide(velocity)

func _die():
	sprite.play('die')
	
func take_dmg(amount):
	sprite.play("hurt")
	health -= amount
	
	if health <= 0:
		_die()

func attack() -> float:
	sprite.play("attack")
	var current_dmg = attack_damage
	
	# check for crit
	if randf() < crit_chance:
		current_dmg = attack_damage*crit_dmg
	
	return current_dmg
		
	
func _ready():
	sprite.play("default")
	Signalbus.connect("enemy_spawn", self, "set_player_reference")

func set_player_reference():
	Signalbus.emit_signal("send_player_reference", self)

func _physics_process(delta):
	_move()
	move_and_slide(velocity)
