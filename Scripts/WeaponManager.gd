extends Node2D

var weapon_pool_right = []
var weapon_pool_left = []

var active_weapons_right = []
var active_weapons_left = []

var time_last_attack_right = 0
var time_last_attack_left = 0
var connected_player = null

onready var dagger_scene = preload("res://Scenes/Dagger.tscn")
onready var current_weapon_right = dagger_scene
onready var current_weapon_left = dagger_scene


func _fill_pool(amount, clear_pool:bool=false):
	if clear_pool:
		weapon_pool_left = []
		weapon_pool_right = []
	
	while len(weapon_pool_right) <= amount:
		weapon_pool_right.append(current_weapon_right.instance())
	while len(weapon_pool_left) <= amount:
		weapon_pool_left.append(current_weapon_left.instance())	
		
func add_to_player(player):
	connected_player = player

func _add_new_weapon_right():
	print('add a new right weapon')
	var weapon_right = weapon_pool_right.pop_front()
	active_weapons_right.append(weapon_right)
	add_child(weapon_right)
	print(active_weapons_right)
	return weapon_right

func _add_new_weapon_left():
	print('add a new left weapon')
	var weapon_left = weapon_pool_left.pop_front()
	active_weapons_left.append(weapon_left)
	add_child(weapon_left)
	return weapon_left
	
func attack(delta):
	time_last_attack_left += delta
	time_last_attack_right += delta
	
	var weapon_right = null
	var weapon_left = null
	if len(active_weapons_right) >= 1:
		weapon_right = active_weapons_right[-1]
	if len(active_weapons_left) >= 1:
		weapon_left = active_weapons_left[-1]
		
	print(weapon_right)
	if not weapon_right:
		weapon_right = _add_new_weapon_right()
	if weapon_right.is_attacking:
		weapon_right = _add_new_weapon_right()
	
	if not weapon_left:
		weapon_left = _add_new_weapon_left()
	if weapon_left.is_attacking:
		weapon_left = _add_new_weapon_left()
	
	if time_last_attack_left >= 1/weapon_left.attack_speed:
		print('left attack')
		weapon_left.attack(delta, connected_player)
		connected_player.attack()
		time_last_attack_left = 0
		
	if time_last_attack_right >= 1/weapon_right.attack_speed:
		print('right attack')
		weapon_right.attack(delta, connected_player)
		connected_player.attack()
		time_last_attack_right=0
		
func _check_active_weapons_right():
	var checked_weapons = []
	while active_weapons_right:
		var weapon = active_weapons_right.pop_front()
		
		if not weapon.is_attacking:
			print('returning %s to the weapon pool'%weapon)
			weapon_pool_right.append(weapon)
		else:
			checked_weapons.append(weapon)
	active_weapons_right = checked_weapons
			
func _check_active_weapons_left():
	var checked_weapons = []
	while active_weapons_left:
		var weapon = active_weapons_left.pop_front()
		
		if not weapon.is_attacking:
			print('returning %s to the weapon pool'%weapon)
			weapon_pool_left.append(weapon)
		else:
			checked_weapons.append(weapon)
	active_weapons_left = checked_weapons

func _check_pools():
	if len(weapon_pool_right) <= 1:
		_fill_pool(2)
	if len(weapon_pool_left) <= 1:
		_fill_pool(2)
# Called when the node enters the scene tree for the first time.
func _ready():
	_fill_pool(30)
	
func _physics_process(delta):
	_check_pools()
	if connected_player:
		_check_active_weapons_left()
		_check_active_weapons_right()
		attack(delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
