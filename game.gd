extends Node2D

@onready var inventorynode = get_node("/root/Game/ScreenControl/TrayBoxContainer/TrayHBoxContainerL/VBoxContainer/InventoryGrid")

@onready var button_remove_plopcorn: Button = %ButtonRemovePlopcorn
@onready var button_remove_bip_soda: Button = %ButtonRemoveBipSoda
@onready var button_add_plopcorn: Button = %ButtonAddPlopcorn
@onready var button_add_bip_soda: Button = %ButtonAddBipSoda


static var inventory := {
	
}

static var items_list := {
	"Bip": "res://scenes/inv_items/inv_bip_soda.tscn",
	"Plopcorn": "res://scenes/inv_items/inv_plopcorn.tscn",
	"Heart Mug": "res://scenes/inv_items/inv_mug_love.tscn",	
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_add_bip_soda.pressed.connect(add_bip_to_inventory)
	button_remove_bip_soda.pressed.connect(remove_bip_from_inventory)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_bip_to_inventory():
	var item_name = "Bip"
	var item_path = "res://scenes/inv_items/inv_bip_soda.tscn"
	inventory[item_name] = item_path
	inventorynode.resetinventorygrid()

func remove_bip_from_inventory():
	inventory.erase("Bip")
	inventorynode.resetinventorygrid()

func add_item_to_inv(item_name: String):
	pass

func remove_item_from_inv(item_name: String):
	pass
