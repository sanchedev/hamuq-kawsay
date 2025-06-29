class_name Player extends CharacterBody2D

@export var speed = 3200

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var input := Vector2.ZERO

func _physics_process(delta: float) -> void:
	input.x = Input.get_axis("left", "right")
	input.y = Input.get_axis("up", "down")
	
	# animations
	if input.x != 0 or input.y != 0:
		animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("idle")
	# movement
	input.normalized()
	velocity = input * speed * delta
	move_and_slide()
