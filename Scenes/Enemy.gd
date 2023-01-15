extends KinematicBody2D


onready var animation_player = $AnimatedSprite
var player
var attack = 5
var movement_speed = 10
var health = 10
var attack_range = 10
var attack_speed = 0.5

func _ready():
	Signalbus.emit_signal("enemy_spawn")
	Signalbus.connect("send_player_reference", self, "set_player_reference")
	print("ready")


func _physics_process(delta):
	var movement_vector = (player.position - self.position).normalized() * movement_speed
	movement_vector = move_and_slide(movement_vector)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		print("I collided with ", collision.collider.name)

func set_player_reference(player_reference):
	self.player = player_reference
