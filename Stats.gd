extends Node

export(int) var max_health setget set_max_health
var health = max_health setget set_health #pass a setter and getter

#print("connected")

signal no_health #check on the child node
signal health_changed(value)
signal max_health_changed(value)

func set_max_health(value):
	max_health = value
	self.health = min(self.health,max_health)
	emit_signal("max_health_changed",max_health)

func set_health(value):
	health = value
	emit_signal("health_changed",health)
	if health <=0:
		emit_signal("no_health")
	
func _ready():
	self.health = max_health
