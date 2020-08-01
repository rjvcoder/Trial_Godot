extends KinematicBody2D
#ctrl+shift+r andtry saving so that it doesnt close
export var ACCELERATION = 500
export var MAX_SPEED = 100
export var ROLL_SPEED = 125
export var FRICTION = 600

#var animationPlayer = null
enum{
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN #we are initially facing down
onready var stats = PlayerStats
#set on animationtree for initial position
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback") #get access to animation tree playback animation
onready var swordHitbox = $HitboxPivot/SwordHitBox

func _ready():
	#wait for it to get ready
	print(stats.health)
	stats.connect("no_health",self,"queue_free")
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector
	
func _process(delta):#_physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
			
		ROLL:
			roll_state(delta)
			
		ATTACK:
			attack_state(delta)	
	
func move_state(delta):
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up")
	
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector #so that we dont roll in place
		swordHitbox.knockback_vector = input_vector
		
		animationTree.set("parameters/Idle/blend_position",input_vector)
		animationTree.set("parameters/Run/blend_position",input_vector)
		animationTree.set("parameters/Attack/blend_position",input_vector)
		animationTree.set("parameters/Roll/blend_position",input_vector)
		animationState.travel("Run") #move while animating
		#velocity += input_vector * ACCELERATION * delta #+ MAX_SPEED
		#velocity = velocity.clamped(MAX_SPEED)
		velocity = velocity.move_toward(input_vector*MAX_SPEED,ACCELERATION*delta)
		#print(velocity)
	else:	
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO,FRICTION*delta)
	#move_and_collide(velocity*delta)
	move()
	
	if Input.is_action_just_pressed("roll"):
			state = ROLL
	if Input.is_action_just_pressed("attack"):
		velocity = Vector2.ZERO
		state = ATTACK
	#if Input.is_action_just_pressed("roll"):
	#	state = ROLL
	
func attack_state(delta):
	animationState.travel("Attack")

func move():
	velocity = move_and_slide(velocity)

func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED #faster
	animationState.travel("Roll")
	move()
	
func roll_animation_finished():
	velocity = Vector2.ZERO #so it wont slide
	state = MOVE

func attack_animation_finished():
	state = MOVE


func _on_HurtBox_area_entered(area):
	pass
	#print("ouch")
	#stats.health-=1
