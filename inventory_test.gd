extends RichTextLabel

@onready var gamenode = get_node("/root/Game")
@onready var inventorynode = get_node("/root/Game/ScreenControl/TrayBoxContainer/TrayHBoxContainerL/VBoxContainer/InventoryGrid")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	refreshinventorytest()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func refreshinventorytest():
	text = ""
	text = "INVENTORY (testing only): "
	for key in gamenode.inventory:
		newline()
		append_text(gamenode.inventory[key]["Name"])
		append_text(": ")
		append_text(gamenode.inventory[key]["Description"])
