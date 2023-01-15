extends Node2D

# preload all needed scenes
var player = preload("res://Scenes/Player.tscn")
var test_map = preload("res://Scenes/TestMap.tscn")
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
	var player1 = player.instance()
	add_child(player1)
	player1.global_position.x = spawn_pos.x
	player1.global_position.y = spawn_pos.y
	
	return player1

func get_time() -> int:
	"""
	Returns the amount of time passed
	in milliseconds since the engine started.
	"""
	elapsed_time = Time.get_ticks_msec()
	
	return elapsed_time
	
# Called when the node enters the scene tree for the first time.
func _ready():
	get_time()
	var player_spawn = _load_map()
	var player1 = _spawn_player(player_spawn)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
