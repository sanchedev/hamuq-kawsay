class_name AlpacaAnimal extends CharacterBody2D

@export var speed = 12

var walking = false
var direction = Vector2i(1,1)

@onready var walking_timer: Timer = $WalkingTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	walking = false
	turning_states()
	randomize()

func _physics_process(delta: float) -> void:
	var waittime = 1
	
	if walking:
		play_anim('walk')
		velocity = direction*speed
	else:
		play_anim('idle')
		velocity = Vector2.ZERO
		
	move_and_slide()

func turning_states():
	if walking:
		walking = false
		walking_timer.wait_time = randf_range(4,8)
		walking_timer.start()
		return
	
	walking = true
	var x = randi_range(-1,1)
	var y = randi_range(-1,1)
	
	direction.x = x
	direction.y = y if y != 0 or x != 0 else randi_range(0, 1) * 2 - 1
	
	walking_timer.wait_time = randf_range(2,6)
	walking_timer.start()

func _on_walking_timer_timeout() -> void:
	turning_states()


func play_anim(anim_name: String):
	var dir
	
	if direction.y != 0:
		dir = 'up' if direction.y < 0 else 'down'
	else:
		dir = 'left' if direction.x < 0 else 'right'
	
	animated_sprite_2d.play(anim_name + '_' + dir)
