extends Area2D

var player = null 

#make sure to look at player collision layer
func can_see_player():
	return player!= null

func _on_PlayerDetectionZone_body_entered(body):
	player = body

func _on_PlayerDetectionZone_body_exited(body):
	player = null
