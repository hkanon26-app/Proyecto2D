extends Control


signal direccion_cambiada(direccion: Vector2)


@export var max_distance: float
var is_dragging := false
var touch_index := -1
var direccion: Vector2 = Vector2.ZERO


@onready var base = $base
@onready var stick = $base/knob
@onready var touch_area = $TouchScreenButton


func _ready() -> void:
	call_deferred("_center_stick_on_base")


func _center_stick_on_base():
	if max_distance <= 0:
		# max_distance es un float, por lo que usamos .x para obtener un solo valor
		max_distance = base.size.x / 2
	
	stick.pivot_offset = stick.size / 2
	stick.position = (base.size - stick.size) / 2

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed and touch_area.is_pressed():
			is_dragging = true
			touch_index = event.index
		elif not event.pressed and event.index == touch_index:
			reset_joystick()
			
	if event is InputEventScreenDrag and is_dragging and event.index == touch_index:
		var local_touch_pos = base.get_local_mouse_position()
		var center = base.size / 2
		var offset = local_touch_pos - center
		
		if offset.length() > max_distance:
			offset = offset.normalized() * max_distance
			
		stick.position = center + offset
		
		var new_direccion = offset / max_distance
		if new_direccion != direccion:
			direccion = new_direccion
			direccion_cambiada.emit(direccion)
		
		_update_input(direccion)

func reset_joystick():
	is_dragging = false
	_center_stick_on_base()
	
	if direccion != Vector2.ZERO:
		direccion = Vector2.ZERO
		direccion_cambiada.emit(direccion)
	
	_update_input(Vector2.ZERO)
	
func _update_input(direction: Vector2):
	# Eje X
	if direction.x < -0.5:
		Input.action_press("move_left")
		Input.action_release("move_right")
	elif direction.x > 0.5:
		Input.action_press("move_right")
		Input.action_release("move_left")
	else:
		Input.action_release("move_left")
		Input.action_release("move_right")

	# Eje Y
	if direction.y < -0.5:
		Input.action_press("move_up")
		Input.action_release("move_down")
	elif direction.y > 0.5:
		Input.action_press("move_down")
		Input.action_release("move_up")
	else:
		Input.action_release("move_up")
		Input.action_release("move_down")
