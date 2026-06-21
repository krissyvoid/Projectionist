extends AudioStreamPlayer
@onready var bgm_button: Button = %bgmButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_bgm_button_pressed() -> void:
	set_stream_paused(!stream_paused)
	if stream_paused:
		bgm_button.icon = load("res://images/ui/Mute_Icon.svg.png")
	elif not stream_paused:
		bgm_button.icon = load("res://images/ui/Speaker_Icon.svg.png")
