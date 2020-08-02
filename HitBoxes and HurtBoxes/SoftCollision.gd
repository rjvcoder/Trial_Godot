extends Area2D

func _is_colliding():
	var areas = get_overlapping_areas()
	return areas.size() > 0
	
func get_push_vector():
	var areas = get_overlapping_areas()
	var push_vector = Vector2.ZERO
	if _is_colliding():
		var area = areas[0]
		push_vector = area.global_position.direction_to(global_position)
		#print(push_vector)
		#push_vector = push_vector.normalized()
		#print(push_vector)
	return push_vector
