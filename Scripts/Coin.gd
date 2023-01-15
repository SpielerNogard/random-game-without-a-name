extends AnimatedSprite

var speed = 1
var player = null

func collect(player):
	player = player

func _fly_to_player(delta):
	if player.global_position.x < global_position.x:
		global_position.x -= speed*delta
	
	if player.global_position.x > global_position.x:
		global_position.x += speed*delta
	
	if player.global_position.y > global_position.y:
		global_position.y += speed*delta
	
	if player.global_position.y < global_position.y:
		global_position.y -= speed*delta
	
	if player.global_position.y == global_position.y and player.global_position.x == global_position.x:
		player.collect_coin()
		queue_free()


# Called when the node enters the scene tree for the first time.
func _ready():
	play("default")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player:
		_fly_to_player(delta)
