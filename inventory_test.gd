extends RichTextLabel

@onready var game_node = get_node("/root/Game")
@onready var inventory_node = get_node("/root/Game/ScreenControl/TrayBoxContainer/TrayHBoxContainerL/VBoxContainer/InventoryGrid")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory_refresh_test()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func inventory_refresh_test():
	text = ""
	text = "INVENTORY (testing only): "
	for item in game_node.inventory:
		newline()
		append_text(game_node.items_list[item]["Name"])
		append_text(": ")
		append_text(game_node.items_list[item]["Description"])
