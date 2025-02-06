extends Node2D


@onready var astar_tiles: TileMapLayer = $AStarTiles

var astar := AStar2D.new()
var points: Dictionary[Vector2i, int]


func _ready() -> void:
	for pos: Vector2i in get_used_cells():
		var id := points.size()
		astar.add_point(id, pos)
		points[pos] = id
		for neighbor: Vector2i in vec2i_neighbors(pos):
			if neighbor in points:
				var neighbor_id := points[neighbor]
				if not astar.are_points_connected(id, neighbor_id):
					astar.connect_points(id, neighbor_id)


func vec2i_neighbors(vec: Vector2i) -> Array[Vector2i]:
	return [
		Vector2i(vec.x + 1, vec.y),
		Vector2i(vec.x - 1, vec.y),
		Vector2i(vec.x, vec.y + 1),
		Vector2i(vec.x, vec.y - 1),
	]


func print_point(id: int) -> void:
	var pos := astar.get_point_position(id)
	var connections := astar.get_point_connections(id)
	print("Id = %d, Pos = %s, Connections = %s" % [id, pos, connections])
