extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text
var value = 1
var fly_to_player = false
var collected = false

func collect():
	fly_to_player = true

func _fly_to_player():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	play("default")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not collected and fly_to_player:
		_fly_to_player()
