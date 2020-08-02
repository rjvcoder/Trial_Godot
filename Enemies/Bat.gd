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
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO,200*delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta )
			seek_player()

			if wanderController.get_time_left() == 0:
				state = pick_random_state([IDLE,WANDER])
				wanderController.start_wander_timer(rand_range(1,3))
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				state = pick_random_state([IDLE,WANDER])
				wanderController.start_wander_timer(rand_range(1,3))
			var direction = global_position.direction_to(wanderController.target_position)
			velocity = velocity.move_toward( direction * MAX_SPEED , ACCCELERATION * delta )
			
			if global_position.distance_to(wanderController.target_position) <= 4:
				state = pick_random_state([IDLE,WANDER])
				wanderController.start_wander_timer(rand_range(1,3))
		CHASE:
			var player = PlayerDetectionZone.player
			if player!=null:
				var direction = global_position.direction_to(player.global_position)#( player.global_position - global_position ).normalized() #unit vector
				velocity = velocity.move_toward( direction * MAX_SPEED , ACCCELERATION * delta )
			else:
				#if Im outside the range
				state = IDLE
			sprite.flip_h = velocity.x < 0
	
	if softCollision._is_colliding():
		velocity +=	 softCollision.get_push_vector() * delta * 400	
	velocity = move_and_slide(velocity)

func seek_player():
	if PlayerDetectionZone.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	
func _on_Area2D_area_entered(area):
	if area.get("knockback_vector"):
		stats.health-=area.damage
		self.knockback = area.knockback_vector * 120
		hurtbox.create_hit_effect()
		
func _on_Stats_no_health():
	queue_free() #delete me when no health
	#small starting letter for instance
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
