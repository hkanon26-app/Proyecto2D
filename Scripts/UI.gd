extends CanvasLayer

var coins = 0
var heart1
var heart2
var heart3
var joystick 

@onready var CoinCollectedText = $CoinCollectedText

func _ready():
	
	
	heart1 = get_node("Heart1")
	heart2 = get_node("Heart2")
	heart3 = get_node("Heart3")
	
	
	joystick = get_node_or_null("Joystick")
	
	if not is_instance_valid(CoinCollectedText):
		print("ERROR: El Label 'CoinCollectedText' no fue encontrado. Verifica su nombre y su ruta (actual: '$CoinCollectedText').")
		return
		
	CoinCollectedText.text = str(coins)
	
	#Configurar Joystick solo en android 
	"""if OS.get_name() == "Android":
		if joystick:
			configure_joystick()
		else:
			print("Advertencia: No encontro el nodo Joystick")
	else:
		if joystick:
			Joystick.visible = false"""
	
	
func configure_joystick():
	if not joystick:
		return
		
		joystick.visible = true
			
		joystick.scale = Vector2(0.5, 0.5)
			
		var screen_size = get_viewport().size
		joystick.position = Vector2(50, screen_size.y -200)
			
		joystick.modulate = Color(1, 1, 1, 0.7)
			
			
func handleCoinCollected():
	print("Moneda Recolectada!")
	coins += 1
	
	if is_instance_valid(CoinCollectedText):
		CoinCollectedText.text = str(coins)
	else:
		print("ADVERTENCIA: No se pudo actualizar el texto de monedas porque 'CoinCollectedText' es nulo en handleCoinCollected.")

	if coins == 10:
		call_deferred("Sigiente_nivel")
	print("Finalizo el nivel")
	
func handleHearts(lifes):
	
	if lifes == 0:
		heart1.visible = false
	
	if lifes == 1:
		heart2.visible = false
		
	if lifes == 2:
		heart3.visible = false
		
func Sigiente_nivel():
	#get_tree().change_scene_to_file("res://Sceness/Mundo2.tscn")
	get_tree().change_scene_to_file("res://Sceness/Mundo" + str(int(get_tree().current_scene.name) + 1) + ".tscn")
