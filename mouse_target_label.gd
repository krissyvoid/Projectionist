extends RichTextLabel

@onready var mouse_ray: RayCast2D = %MouseRay
@onready var game_node = get_node("/root/Game")
@onready var player = get_node("/root/Game/World/Player")

var mouse_target : Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


# Updates the text box every second
func update():
	await get_tree().create_timer(1.0).timeout
	var mouseloc := str(get_global_mouse_position())
	set_text("")
	set_text(game_node._target_trim)
	newline()
	append_text(mouseloc)
	newline()
	append_text("Player velocity: ")
	append_text(str(player.velocity))
	newline()
	append_text("Player real velocity: ")
	var truevelocity = player.get_real_velocity()
	append_text(str(truevelocity))
	update()
