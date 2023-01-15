extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var level = 1
var weapon_name = "dagger"
var description = "A Dagger"

var projectiles = 1
var dmg = 1
var penetration = 1
var sprite = null
var player = null

onready var my_sprite = get_node("Sprite")
	
func equip_weapon(player, weapon_name):
	weapon_name = weapon_name
	player = player
	
func _load_sprite():
	sprite = load("res://Assets/Weapons/%s.png"%weapon_name)

# Called when the node enters the scene tree for the first time.
func _ready():
	_load_sprite()
	pass # Replace with function body.

func attack(enemy):
	my_sprite.texture = sprite
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	attack()
