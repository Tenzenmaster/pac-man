extends Node2D


const PACMAN_MOVE_SPEED := 64.0


@onready var astar_tiles: TileMapLayer = $AStarTiles
@onready var pacman: AnimatedSprite2D = $PacMan


var astar := AStar2D.new()
var points: Dictionary[Vector2, int]
var input_direction := Vector2.RIGHT
var pacman_direction := Vector2.RIGHT
var pacman_target_position := Vector2.ZERO


func _ready() -> void:
	astar_tiles.hide()
	init_astar()
	pacman_target_position = pacman.position + Vector2(8.0, 0.0)


func _process(delta: float) -> void:
	update_input_direction()
	
	if pacman.position == pacman_target_position:
		var input_target_tile := astar_tiles.local_to_map(pacman.position) as Vector2 + input_direction
		var default_target_tile := astar_tiles.local_to_map(pacman.position) as Vector2 + pacman_direction
		if input_direction != pacman_direction and input_target_tile in points:
			pacman_direction = input_direction
			pacman_target_position = astar_tiles.map_to_local(input_target_tile)
		elif default_target_tile in points:
			pacman_target_position = astar_tiles.map_to_local(default_target_tile)
	
	pacman.position = pacman.position.move_toward(pacman_target_position, PACMAN_MOVE_SPEED * delta)


func update_input_direction() -> void:
	var input_x := Input.get_axis(&"move_left", &"move_right")
	if input_x:
		input_direction = Vector2(input_x, 0.0)
	else:
		var input_y := Input.get_axis(&"move_up", &"move_down")
		if input_y:
			input_direction = Vector2(0.0, input_y)


func init_astar() -> void:
	for pos: Vector2 in astar_tiles.get_used_cells():
		var id := points.size()
		astar.add_point(id, pos)
		points[pos] = id
		for neighbor: Vector2 in vec2i_neighbors(pos):
			if neighbor in points:
				var neighbor_id := points[neighbor]
				if not astar.are_points_connected(id, neighbor_id):
					astar.connect_points(id, neighbor_id)


func vec2i_neighbors(vec: Vector2) -> Array[Vector2]:
	return [
		Vector2(vec.x + 1, vec.y),
		Vector2(vec.x - 1, vec.y),
		Vector2(vec.x, vec.y + 1),
		Vector2(vec.x, vec.y - 1),
	]


func print_point(id: int) -> void:
	var pos := astar.get_point_position(id)
	var connections := astar.get_point_connections(id)
	print("Id = %d, Pos = %s, Connections = %s" % [id, pos, connections])
