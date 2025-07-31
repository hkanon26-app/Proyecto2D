extends Area2D


class_name Joystick


@export var base_radius = 80
@export var handle_radius = 40

var distancia: float
var direccion: Vector2
var index: int = -1
@onready var rango = $Rango
@onready var palanca = $Palanca
@onready var radio = $CollisionShape2D.shape.radius

var is_dragging = false
var output = Vector2.ZERO


func get_axis() -> Vector2:
	return output


func _ready() -> void:
	add_to_group("joystick")
	 
	if OS.get_name() != "Android":
		visible = false

func _process(_delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.is_pressed() and index == -1:
			distancia = global_position.distance_to(event.position)
			if distancia <= radio:
				index = event.index
				palanca.global_position = event.position
				distancia = (event.position - global_position).normalized() * (distancia /  radio)
		elif event.index == index:
			index = -1
			palanca.position = Vector2.ZERO
			direccion = Vector2.ZERO
			
	if event is InputEventScreenDrag:
		if event.index == index:
			distancia = global_position.distance_to(event.position)
			if distancia <= radio:
				palanca.global_position = event.position
				direccion = (event.position - global_position).normalized() * (distancia / radio)
			else:
				direccion = (event.position - global_position).normalized()
				palanca.global_position = global_position + (direccion * radio)
