extends Node2D

var weapon_pool_right = []
var weapon_pool_left = []

var active_weapons_right = []
var active_weapons_left = []

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
	var weapon_right = weapon_pool_right.pop_front()
	add_child(weapon_right)
	return weapon_right

func _add_new_weapon_left():
	var weapon_left = weapon_pool_left.pop_front()
	add_child(weapon_left)
	return weapon_left
	
func attack(delta):
	var weapon_right = active_weapons_right.pop_back()
	var weapon_left = active_weapons_left.pop_back()
	
	if not weapon_right:
		weapon_right = _add_new_weapon_right()
	if weapon_right.is_attacking:
		weapon_right = _add_new_weapon_right()
	
	if not weapon_left:
		weapon_left = _add_new_weapon_left()
	if weapon_left.is_attacking:
		weapon_left = _add_new_weapon_left()
		
	weapon_right.attack(delta, connected_player)
	weapon_left.attack(delta, connected_player)
	
func _check_active_weapons_right():
	var checked_weapons = []
	while active_weapons_right:
		var weapon = active_weapons_right.pop_front()
		
		if not weapon.is_attacking:
			weapon_pool_right.append(weapon)
		else:
			checked_weapons.append(weapon)
	active_weapons_right = checked_weapons
			
func _check_active_weapons_left():
	var checked_weapons = []
	while active_weapons_left:
		var weapon = active_weapons_left.pop_front()
		
		if not weapon.is_attacking:
			weapon_pool_left.append(weapon)
		else:
			checked_weapons.append(weapon)
	active_weapons_left = checked_weapons

func _check_pools():
	if len(weapon_pool_right) <= 10:
		_fill_pool(30)
	if len(weapon_pool_left) <= 10:
		_fill_pool(30)
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
