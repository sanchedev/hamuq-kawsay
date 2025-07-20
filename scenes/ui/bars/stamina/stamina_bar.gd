class_name StaminaBar extends TextureProgressBar

@export var player: Player

@onready var inactive_timer: Timer = $InactiveTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_visible = false

func _ready() -> void:
	player.connect('stamina_changing', _on_stamina_changing)

func _on_stamina_changing(stamina: float, max_stamina: float):
	if !is_visible: animation_player.play("fade_in")
	is_visible = true
	var val = 1 - (stamina/max_stamina)
	value = val * 100
	inactive_timer.start(0)

func _on_inactive_timer_timeout() -> void:
	animation_player.play('fade_out')
	is_visible = false
