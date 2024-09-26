@tool
extends Node2D
class_name LightningBolt
@export var target : Node2D = Marker2D.new()
@export var lightning : Line2D = Line2D.new()

var calc_points : PackedVector2Array
var last_point : Vector2
var animation_timer : float = 0.0
var angle_var : float = 30.0


func _process(delta: float) -> void:
	last_point = to_local(target.global_position) - to_local(global_position)
	animation_timer -= delta
	if animation_timer <= 0:
		create_points()
		animation_timer = randf_range(0.01, 0.03)


func create_points():
	update_points()
	lightning.points = calc_points
	calc_points.clear()



func update_points():
	var curr_line_len = 0
	var start_point = to_local(global_position)
	var min_segment_size = max(Vector2().distance_to(last_point)/20,10)
	var max_segment_size = min(Vector2().distance_to(last_point)/30,40)
	calc_points.append(start_point)
	while(curr_line_len < Vector2().distance_to(last_point)):
		var move_vector = start_point.direction_to(last_point) * randf_range(min_segment_size,max_segment_size)
		var new_point = start_point + move_vector
		var new_point_rotated = start_point + move_vector.rotated(deg_to_rad(randf_range(-angle_var,angle_var)))
		calc_points.append(new_point_rotated)
		start_point = new_point
		curr_line_len = start_point.length()
		
	calc_points.append(last_point)
