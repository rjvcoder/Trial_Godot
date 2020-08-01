extends Node2D

#preload so we dont load it again and again
const GrassEffect = preload("res://Effects/GrassEffect.tscn")

func create_grass_effect():#_process(delta):
	#from other scripts
	var grassEffect = GrassEffect.instance()
	get_parent().add_child(grassEffect)
	grassEffect.global_position = global_position #animate on the position

	#if Input.is_action_just_pressed("attack"):
				#queue_free() #removed destroyed items in the game


func _on_Area2D_area_entered(area):
	create_grass_effect()
	queue_free()
