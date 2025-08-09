extends CanvasLayer

var coins = 0
var heart1
var heart2
var heart3
var control 

@onready var CoinCollectedText = $CoinCollectedText

func _ready():
	
	
	heart1 = get_node("Heart1")
	heart2 = get_node("Heart2")
	heart3 = get_node("Heart3")
	
	
	control = get_node_or_null("GUI/Control")
	
	if not is_instance_valid(CoinCollectedText):
		print("ERROR: El Label 'CoinCollectedText' no fue encontrado. Verifica su nombre y su ruta (actual: '$CoinCollectedText').")
		return
		
	CoinCollectedText.text = str(coins)
	
	
func configure_joystick():
	if not Control:
		return
		
	Control.visible = true
			
	Control.scale = Vector2(0.5, 0.5)
			
	var screen_size = get_viewport().size
	Control.position = Vector2(50, screen_size.y -200)
			
	Control.modulate = Color(1, 1, 1, 0.7)
			
			
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
