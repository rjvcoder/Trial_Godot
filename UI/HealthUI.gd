extends Control

onready var hearts = 4 setget set_hearts
onready var max_hearts = 4 setget set_max_hearts

#onready var label = $Label

onready var heartUIEmpty = $HeartUIEmpty
onready var heartUIFull = $HeartUIFull

func set_hearts(value):
	print("asas")
	hearts = clamp(value, 0, max_hearts)
	if heartUIFull != null :
		heartUIFull.rect_size.x = hearts*15 #15 pixels width
	
func set_max_hearts(value):
	max_hearts = max(value,1)
	self.hearts = min(self.hearts,max_hearts)
	if heartUIEmpty != null:
		heartUIEmpty.rect_size.x = max_hearts * 15

func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed",self,"set_hearts")
	PlayerStats.connect("max_health_changed",self,"set_max_hearts")
