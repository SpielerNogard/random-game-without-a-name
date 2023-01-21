extends Node2D

# preload all needed scenes
var player_scene = preload("res://Scenes/Player.tscn")
var enemy_scene = preload("res://Scenes/Bat.tscn")
var test_map = preload("res://Scenes/TestMap.tscn")
var weapon_manager_scene = preload("res://Scenes/WeaponManager.tscn")
var elapsed_time = 0 # millisecs

var MAPS = {
	'TestMap':{'MAP':test_map,
			   'POSX':100,
			   'POSY':100}
					}
					
func _load_map(map_name:String='TestMap') -> Vector2:
	"""
	Loads a new map instance.
	
	Parameters
	----------
	map_name : String
		Name of map that should be loaded.
	
	Returns
	-------
	spawn_pos : Vector2
		The global_position where the player should be spawned.
	"""
	var map_info = MAPS[map_name]
	
	add_child(map_info['MAP'].instance())
	
	return Vector2(map_info['POSX'], map_info['POSY'])

func _spawn_player(spawn_pos:Vector2):
	"""
	Spawn a new player at position.
	
	Parameters
	----------
	spawn_pos : Vector2
		spawn position of player in map.
	
	Returns
	-------
	player : 
		The spawned player instance
	"""
	var player1 = player_scene.instance()
	add_child(player1)
	player1.global_position.x = spawn_pos.x
	player1.global_position.y = spawn_pos.y
	
	return player1

func _spawn_enemy(spawn_pos:Vector2):
	"""
	Spawn a new enemy at position.
	
	Parameters
	----------
	spawn_pos : Vector2
		spawn position of enemy in map.
	
	Returns
	-------
	enemy : 
		The spawned enemy instance
	"""
	print(getCurrentCamera2D())
	var enemy1 = enemy_scene.instance()
	add_child(enemy1)
	enemy1.global_position.x = spawn_pos.x
	enemy1.global_position.y = spawn_pos.y
	
	return enemy1

func getCurrentCamera2D():
	var viewport = get_viewport()
	if not viewport:
		return null
	var camerasGroupName = "__cameras_%d" % viewport.get_viewport_rid().get_id()
	var cameras = get_tree().get_nodes_in_group(camerasGroupName)
	for camera in cameras:
		if camera is Camera2D and camera.current:
			return camera
	return null

func get_time() -> int:
	"""
	Returns the amount of time passed
	in milliseconds since the engine started.
	"""
	elapsed_time = Time.get_ticks_msec()
	
	return elapsed_time

func _create_weapon_manager(player):
	var weapon_manager = weapon_manager_scene.instance()
	add_child(weapon_manager)
	weapon_manager.add_to_player(player)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	Signalbus.connect("player_died", self, "player_died")
	Signalbus.connect("enemy_death", self, "enemy_died")
	
	get_time()
	var player_spawn = _load_map()
	var player1 = _spawn_player(player_spawn)
	_create_weapon_manager(player1)
	for i in range(10):
		_spawn_enemy(player_spawn + Vector2(i, i))

func player_died(player):
	get_tree().reload_current_scene()

func enemy_died(enemy):
	pass
	#_spawn_enemy()
