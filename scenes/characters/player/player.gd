class_name Player extends CharacterBody2D

@export var speed = 40
@export var run_speed = 80
@export var max_stamina = 5

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var stamina_timer: Timer = $StaminaTimer

# Signals
signal stamina_changing(stamina: float, max_stamina: float)

var input := Vector2.ZERO
var sufix: String = "down"
var stamina = 0
var stamina_timer_playing = false

func _physics_process(delta: float) -> void:
	input.x = Input.get_axis("left", "right")
	input.y = Input.get_axis("up", "down")
	
	var is_running := Input.is_action_pressed("run")
	
	# animations
	if input.y < 0: sufix = "up"
	elif input.y > 0: sufix = "down"
	elif input.x > 0: sufix = "right"
	elif input.x < 0: sufix = "left"
	
	if input.x != 0 or input.y != 0:
		if is_running:
			animated_sprite_2d.play("run_"+sufix)
		else:
			animated_sprite_2d.play("walk_"+sufix)
	else:
		animated_sprite_2d.play("idle_"+sufix)
	# movement
	velocity = input.normalized()
	
	if input.x != 0 or input.y != 0:
		if is_running:
			if stamina < max_stamina:
				velocity *= run_speed
			else:
				velocity *= speed
		else:
			velocity *= speed
	
	move_and_slide()
	
	# Stamina
	if (input.x != 0 or input.y != 0) and is_running:
		stamina += delta
		if stamina >= max_stamina:
			stamina = max_stamina
		stamina_changing.emit(stamina, max_stamina)
	elif stamina == max_stamina :
		if !stamina_timer_playing:
			stamina_timer.start(0)
			stamina_timer_playing = true
		else:
			stamina_changing.emit(stamina, max_stamina)
	elif stamina > 0 and !stamina_timer_playing:
		stamina -= delta
		if stamina < 0: stamina = 0
		stamina_changing.emit(stamina, max_stamina)


func _on_stamina_timer_timeout() -> void:
	stamina_timer_playing = false
	stamina -= 0.001
