extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Obtenemos la gravedad de los ajustes del proyecto
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Sensibilidad del ratón para mirar alrededor
var mouse_sensitivity = 0.002

# Conectamos la cámara que acabas de crear
@onready var camera = $Camera3D

# Conectar el personaje con las animaciones
@onready var animation_player: AnimationPlayer = $"Animacion niño/AnimationPlayer"

#Conectar cuerpo con el código
@onready var animacion_niño: Node3D = $"Animacion niño"
@onready var modelo = $"Animacion niño"

func _ready():
	# Esto hace que el ratón desaparezca y se quede atrapado en el juego
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	# 1. Movimiento con el ratón (Para cuando pruebes en el PC)
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if camera != null: # <--- Aquí está la trampa de seguridad
			rotate_y(-event.relative.x * mouse_sensitivity)
			camera.rotate_x(-event.relative.y * mouse_sensitivity)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
	# ... el resto de tu código de rotación ...
	# 2. Movimiento tocando la pantalla (Para el Celular)
	if event is InputEventScreenDrag:
		# Solo mueve la cámara si deslizamos el dedo en la MITAD DERECHA de la pantalla
		if event.position.x > get_viewport().size.x / 2:
			# El celular es más sensible, bajamos un poco la velocidad multiplicando por 0.5
			rotate_y(-event.relative.x * mouse_sensitivity * 0.5)
			camera.rotate_x(-event.relative.y * mouse_sensitivity * 0.5)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
			
	# Liberar el ratón con la tecla ESC
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta):
	# Añadir gravedad si no estamos tocando el piso
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Saltar con la barra espaciadora
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 1. Escuchamos las teclas WASD que acabamos de crear
	var input_dir = Input.get_vector("derecha", "izquierda", "adelante", "atras")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# 2. Si hay dirección (estamos presionando alguna tecla)
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		# ¡Arrancamos a caminar!
		animation_player.play("walk_com") 
		
		# (Aquí mantienes la rotación que te funcionó en el paso anterior, por ejemplo 180 o 90)
		modelo.rotation_degrees.y = 180 
		
	# 3. Si NO hay dirección (soltamos las teclas)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
		# ¡Nos quedamos quietos respirando!
		animation_player.play("Idle_com_001")
		
		# Mantenemos la misma rotación para que no se voltee al parar
		modelo.rotation_degrees.y = 90 

	# Aplicamos todo el movimiento y colisiones al final
	move_and_slide()
