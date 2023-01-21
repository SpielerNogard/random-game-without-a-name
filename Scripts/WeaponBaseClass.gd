extends Node2D
class_name Weapon

var crit_chance = 0
var crit_multi = 1

var damage = 0
var attack_speed = 1
var is_attacking = false

var time_since_last_attack = 0

func _is_crit()-> bool:
	if randf() <= crit_chance:
		return true
	return false

func _get_dmg(crit:bool=false):
	if crit:
		return damage*crit_multi
	return damage

func attack(delta, player):
	print('attacking')
	self.is_attacking = true
	self.visible = true
	self._attack(player)

func _attack(player):
	print('I hope this is not printed')
	pass
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
