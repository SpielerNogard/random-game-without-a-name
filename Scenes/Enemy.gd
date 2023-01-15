extends KinematicBody2D


onready var animation_player = $AnimatedSprite
var player
var attack = 5
var movement_speed = 30
var health = 10
var attack_range = 10
var attack_speed = 0.5

func _ready():
	Signalbus.connect("send_player_reference", self, "set_player_reference")
	Signalbus.emit_signal("enemy_spawn")


func _physics_process(delta):
	var movement_vector = (player.position - self.position).normalized() * movement_speed
	movement_vector = move_and_slide(movement_vector, 
	 Vector2( 0, 0 ), false, 4, 0.785398, false)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		var collision_body = collision.collider
		if collision_body.is_in_group("player"):
			print("KILL KILL KILL")

func set_player_reference(player_reference):
	self.player = player_reference
