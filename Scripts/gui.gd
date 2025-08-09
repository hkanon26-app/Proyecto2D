extends CanvasLayer

signal enviar_joystick(j: Joystick)

@onready var label = $Label
@onready var joystick = $Joystick


func _ready() -> void:
	enviar_joystick.emit(joystick)


func _process(_delta: float) -> void:
	label.text = str(joystick.direccion)
