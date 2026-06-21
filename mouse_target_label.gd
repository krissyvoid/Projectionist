extends RichTextLabel

@onready var mouse_ray: RayCast2D = %MouseRay
@onready var game_node = get_node("/root/Game")

var mouse_target : Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var mouseloc := str(get_global_mouse_position())
	set_text("")
	set_text(game_node._target_trim)
	newline()
	append_text(mouseloc)
	
	
	
