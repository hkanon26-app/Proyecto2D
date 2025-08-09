extends CanvasLayer

@onready var label = $Label
@onready var joystick_control = $control

func _ready() -> void:
	if joystick_control:
		joystick_control.direccion_cambiada.connect(_on_joystick_direccion_cambiada)

# Esta función se ejecutará automáticamente cuando el joystick emita la señal
func _on_joystick_direccion_cambiada(direccion: Vector2) -> void:
	label.text = "Dirección: " + str(direccion.round())
