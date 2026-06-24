extends CharacterBody2D

## Player's maximum movement speed
const MAX_SPEED = 300.0
## Player's movement acceleration
const ACCELERATION = 12000.0

@onready var world: Area2D = $".."
@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var game: Node2D = $"../.."

var go_to_pos: Vector2
var mousemove: bool
static var mouseinworld: bool = true

@onready var player_nav_agent: NavigationAgent2D = $PlayerNavAgent
var direction := Vector2(0,0)
signal playernav_finished

func _ready():
	go_to_pos = self.position

func _input(event):	
	if Input.get_axis("move_left", "move_right") != 0.0 or Input.get_axis("move_up", "move_down") != 0.0:
		mousemove = false
	elif mouseinworld and event.is_action_pressed("lmb") and game.active_verb < 1:
		mousemove = true
		game._take_target = "Nothing"
		game.popcontent = ""
		game.popspawnpos = Vector2.ZERO
		go_to_pos = get_global_mouse_position()


func _physics_process(delta: float) -> void:
	if mousemove: #and game.active_verb == 0:
			# Navigate to most recent destination
		if go_to_pos != Vector2.ZERO:
			navigate_to(go_to_pos)
		
	else:
		# Keyboard movement
		direction.x = Input.get_axis("move_left","move_right")
		direction.y = Input.get_axis("move_up","move_down")
	
		velocity = direction * MAX_SPEED / 2
		position += velocity * delta
		move_and_slide()
	
	
	# Ensure the player is facing the correct way for their movement
	var distance2 := global_position.direction_to(go_to_pos)
	if velocity.x > 100.0 and distance2.x < 16:
		$Sprite2D.flip_h = false
	elif velocity.x < -100.0 and distance2.x < 16:
		$Sprite2D.flip_h = true
	else:
		pass
		

func navigate_to(destination : Vector2):
	# Navigate player to destination
	player_nav_agent.target_position = destination
	direction = global_position.direction_to(player_nav_agent.get_next_path_position())
		
	if player_nav_agent.is_navigation_finished() == false:
		velocity = direction * MAX_SPEED
		move_and_slide()
	if player_nav_agent.is_navigation_finished() == true:
		go_to_pos = Vector2.ZERO
		return


func _on_world_mouse_entered() -> void:
	mouseinworld = true
	print("Mouse is in world")

func _on_world_mouse_exited() -> void:
	mouseinworld = false
	print("Mouse is out of world")


func _on_player_nav_agent_navigation_finished() -> void:
	print("playernav_finished emitted")
	playernav_finished.emit()
	return
