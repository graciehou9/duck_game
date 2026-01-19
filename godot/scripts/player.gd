extends CharacterBody2D

var orange_scene = preload("uid://c2xcrq0dqp6vy")
var win_texture = preload("uid://bs5ubv754lfb7")
var lose_texture = preload("uid://dkvuqulbbmpd2")
const SPEED = 450.0

var start_music = preload("uid://bus3k7i4f3rec")
var win_music = preload("uid://oehkveri7bax")
var lose_music = preload("uid://kw6h1fb80fv3")
var sound_music = preload("uid://brf0mkp6o07br")
var pop_sound = preload("uid://bk17es60bhgbc")

var lives = 3
var score = 0
var gameover =  false
var hit_timer = 0.0

func shoot():
	var bullet = orange_scene.instantiate()
	bullet.position = position
	get_parent().call_deferred("add_child", bullet)
	var music_player = get_parent().get_node("AudioStreamPlayer")
	if music_player:
		music_player.stream = pop_sound
		music_player.play()

func _ready():
	var music_player = get_parent().get_node("AudioStreamPlayer")
	if music_player:
		music_player.stream = start_music
		music_player.play()
		
	var music_player2 = get_parent().get_node("AudioStreamPlayer2")
	if music_player2:
		music_player2.stream = sound_music
		music_player2.play()
	

func _physics_process(delta: float) -> void:
	var hit_image = get_parent().get_node("Hit")
	if hit_image:
		if hit_timer > 0:
			hit_image.visible = true 
			hit_timer -= delta     
		else:
			hit_image.visible = false 

	if gameover:
		return
	if lives<1:
		gameover = true
		var lose_bg = get_parent().get_node("TextureRect")
		if lose_bg:
			lose_bg.texture = lose_texture
		#return
		get_tree().call_group("enemies", "queue_free")
		var music_player = get_parent().get_node("AudioStreamPlayer")
		if music_player:
			music_player.stream = lose_music
			music_player.play()
	
	if score>2:
		gameover = true
		var win_bg = get_parent().get_node("TextureRect")
		if win_bg:
			win_bg.texture = win_texture
		
		get_tree().call_group("enemies", "queue_free")
		var music_player = get_parent().get_node("AudioStreamPlayer")
		if music_player:
			music_player.stream = win_music
			music_player.play()
		

	# Handle shoot.
	if Input.is_action_just_pressed("shoot"):
		shoot()
		
	var ydirection := Input.get_axis("up", "down")
	if ydirection:
		velocity.y = ydirection * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	

	
