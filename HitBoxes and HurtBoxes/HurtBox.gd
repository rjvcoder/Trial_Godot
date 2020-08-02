extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

var invincible = false setget set_invincible

onready var timer = $Timer

signal invincibility_started
signal invincibility_ended

#export(bool) var show_hit = true
#shift Tab
func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)
	
func create_hit_effect():#_on_HurtBox_area_entered(area):
	#if show_hit:
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position #- Vector2(0,8)


func _on_Timer_timeout():
	#when calling setter outside its function, add self.
	self.invincible = false

func _on_HurtBox_invincibility_started():
	set_deferred("monitorable",false)
	#monitorable = false
	
func _on_HurtBox_invincibility_ended():
	monitorable = true
