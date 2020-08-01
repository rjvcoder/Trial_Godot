extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
export var ACCCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var state = CHASE

onready var stats = $Stats
onready var PlayerDetectionZone = $PlayerDetectionZone
onready var sprite = $AnimatedSprite

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO,200*delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta )
			seek_player()

		WANDER:
			pass

		CHASE:
			var player = PlayerDetectionZone.player
			if player!=null:
				var direction = ( player.global_position - global_position ).normalized() #unit vector
				velocity = velocity.move_toward( direction * MAX_SPEED , ACCCELERATION * delta )
			else:
				#if Im outside the range
				state = IDLE
				
			sprite.flip_h = velocity.x < 0
			
	velocity = move_and_slide(velocity)

func seek_player():
	if PlayerDetectionZone.can_see_player():
		state = CHASE
	
func _on_Area2D_area_entered(area):
	if area.get("knockback_vector"):
		stats.health-=area.damage
		self.knockback = area.knockback_vector * 120

func _on_Stats_no_health():
	queue_free() #delete me when no health
	#small starting letter for instance
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
