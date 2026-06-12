extends CharacterBody2D

@onready var world: Area2D = $".."
@onready var sprite_2d: Sprite2D = %Sprite2D

## Player's maximum movement speed
@export var max_speed = 300.0
## Player's movement acceleration
@export var acceleration = 12000.0

var go_to_pos: Vector2
var mousemove: bool
@export var mouseinworld: bool = false

func _ready():
	go_to_pos = self.position

func _input(event):	
	if mouseinworld == true:
		if event.is_action_pressed("lmb"):
			mousemove = true
			go_to_pos = get_global_mouse_position()


	if Input.get_axis("move_left", "move_right") != 0.0:
		mousemove = false
	if Input.get_axis("move_up", "move_down") != 0.0:
		mousemove = false


func _physics_process(delta: float) -> void:
	# Mouse-controlled movement
	if mousemove == true:
		var direction := global_position.direction_to(go_to_pos)
		var distance := global_position.distance_to(go_to_pos)
		var speed : float = max_speed if distance > 32 else max_speed * distance / 50

		var desired_velocity := direction * speed
	
		velocity = velocity.move_toward(desired_velocity, acceleration * delta)
		move_and_slide()
		
	else:
		var direction := Vector2(0,0)
		direction.x = Input.get_axis("move_left","move_right")
		direction.y = Input.get_axis("move_up","move_down")
	
		velocity = direction * max_speed / 15
		position += velocity * delta
		move_and_slide()
	
	# Ensure the player is facing the correct way for their movement
	if velocity.x > 0.0:
		$Sprite2D.flip_h = false
	if velocity.x < 0.0:
		$Sprite2D.flip_h = true


func _on_world_mouse_entered() -> void:
	mouseinworld = true
	#print("Mouse is in world")


func _on_world_mouse_exited() -> void:
	mouseinworld = false
	#print("Mouse is out of world")
