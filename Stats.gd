extends Node

export(int) var max_health = 1
onready var health = max_health setget set_health #pass a setter and getter
#print("connected")
signal no_health #check on the child node

func set_health(value):
	health = value
	if health <=0:
		emit_signal("no_health")
	
