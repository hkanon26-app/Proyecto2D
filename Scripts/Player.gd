extends CharacterBody2D

# Configuración calibrada para movimiento natural
const MOVE_SPEED = 120
const JUMP_FORCE = -310
const GRAVITY = 22
const MAX_HORIZONTAL_SPEED = 150
const ACCELERATION = 15
const FRICTION = 20

@onready var sprite = $Sprite2D
@onready var animationPlayer = $AnimationPlayer
# Eliminamos la referencia directa ya que los controles no son hijo del jugador
var joystick = null

var lifes = 3
var is_jumping := false

func _ready():
	# Buscar controles móviles en la escena
	joystick = get_tree().get_first_node_in_group("joystick")
	
	if joystick:
		# Conectar señal de salto
		joystick.jump_pressed.connect(_on_mobile_jump)
		print("Joystick móviles conectados!")
	else:
		print("No se encontraron Joystick móviles")

func _physics_process(_delta):
	# 1. Aplicar gravedad
	if not is_on_floor():
		velocity.y += GRAVITY
	else:
		is_jumping = false
	
	# 2. Obtener dirección de movimiento
	var move_direction := Vector2.ZERO
	
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
		# Suavizar la dirección del joystick
		move_direction.x = Input.get_axis("ui_left", "ui_right")
	elif joystick and joystick.is_dragging:
		move_direction = joystick.get_axis()
	
	# 3. Aplicar movimiento horizontal con aceleración
	if move_direction.x != 0:
		velocity.x = move_toward(velocity.x, move_direction.x * MOVE_SPEED, ACCELERATION)
	else:
		# Fricción cuando no hay input
		velocity.x = move_toward(velocity.x, 0, FRICTION)
	
	# 4. Manejar saltos
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			_perform_jump()
	# Nota: El salto móvil se maneja mediante la señal conectada
	
	# 5. Manejar animaciones
	update_animations(move_direction)
	
	# 6. Mover el personaje (SOLO UNA VEZ)
	move_and_slide()

func _perform_jump():
	velocity.y = JUMP_FORCE
	is_jumping = true
	animationPlayer.play("Jump")

func update_animations(direction: Vector2):
	if not is_on_floor():
		print("Aimacion salto")
		animationPlayer.play("Jump")
	elif direction.x != 0:
		sprite.flip_h = direction.x > 0
		print("Animasion naminar")
		animationPlayer.play("Walk")
	else:
		print("Animacion parado")
		animationPlayer.play("Idle")

func _on_mobile_jump():
	if is_on_floor():
		_perform_jump()

func add_Coin():
	var canvasLayer = get_tree().get_root().find_child("CanvasLayer", true, false)
	
	if canvasLayer:
		canvasLayer.handleCoinCollected()
	else:
		push_warning("CanvasLayer no encontrado para añadir moneda")

func _loseLife(enemyposx):
	# Aplicar knockback
	if position.x < enemyposx: 
		velocity.x = -200
		velocity.y = -100
	else: 
		velocity.x = 200
		velocity.y = -100
	
	move_and_slide()  # Aplicar el knockback inmediatamente
	
	lifes -= 1
	print("Perdiste una vida, Vida actual= " + str(lifes))
	
	var canvasLayer = get_tree().get_root().find_child("CanvasLayer", true, false)
	if canvasLayer:
		canvasLayer.handleHearts(lifes)
	
	if lifes <= 0:
		get_tree().reload_current_scene()

func _on_spikes_body_entered(body: Node2D) -> void:
	if body == self:
		print("Hemos pinchado")
		# Obtener la posición del spike que nos golpeó
		var _spike_position = Vector2.ZERO
		
		# Buscar el spike que causó la colisión
		for i in get_slide_collision_count():
			var collision  = get_slide_collision(i)
			if collision.get_collider().is_in_group("spikes"):
				_spike_position = collision.get_collider().global_position
				break
				
		# Si no encontramos un spike específico, usar la posición actual
		if _spike_position == Vector2.ZERO:
			_spike_position = global_position
			
		# Aplicar el mismo comportamiento que con los enemigos
		_loseLife(_spike_position.x)
		#call_deferred("reiniciar_escena")

#func reiniciar_escena():
#	get_tree().change_scene_to_file("res://Sceness/Menu.tscn")
