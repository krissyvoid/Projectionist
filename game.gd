extends Node2D

## Hello, Github, it's me

@onready var inventorynode = get_node("/root/Game/ScreenControl/TrayBoxContainer/TrayHBoxContainerL/VBoxContainer/InventoryGrid")
@onready var inventory_test: RichTextLabel = %InventoryTest
@onready var mouse_ray: RayCast2D = %MouseRay

@onready var button_remove_plopcorn: Button = %ButtonRemovePlopcorn
@onready var button_remove_bip_soda: Button = %ButtonRemoveBipSoda
@onready var button_add_plopcorn: Button = %ButtonAddPlopcorn
@onready var button_add_bip_soda: Button = %ButtonAddBipSoda

## ------------------------------------ ITEM AND INVENTORY DICTIONARIES ----------------------------
static var inventory := {
	"Bip": {"Name": "Bip Soda",
		"Scene": "res://scenes/inv_items/inv_bip_soda.tscn",
		"Image": "res://images/items/bip_soda.png",
		"Description": "32oz of delicious Bip! Mmmmm, rat blood flavour"
		},
	"Plopcorn": {"Name": "Tub of Plopcorn",
		"Scene": "res://scenes/inv_items/inv_plopcorn.tscn",
		"Image": "res://images/items/plopcorn.png",
		"Description": "A big tub of fresh-ish plopcorn, govered in goop"
		},
	"Heart Mug": {"Name": "Heart Mug",
		"Scene": "res://scenes/inv_items/inv_mug_love.tscn",
		"Image": "res://images/items/mugheart.png",
		"Description": "What's this doing here?"
		},	
}

static var items_list := {
	"Bip": {"Name": "Bip Soda",
		"Scene": "res://scenes/inv_items/inv_bip_soda.tscn",
		"Image": "res://images/items/bip_soda.png",
		"Description": "32oz of delicious Bip! Mmmmm, rat blood flavour"
		},
	"Plopcorn": {"Name": "Tub of Plopcorn",
		"Scene": "res://scenes/inv_items/inv_plopcorn.tscn",
		"Image": "res://images/items/plopcorn.png",
		"Description": "A big tub of fresh-ish plopcorn, govered in goop"
		},
	"Heart Mug": {"Name": "Heart Mug",
		"Scene": "res://scenes/inv_items/inv_mug_love.tscn",
		"Image": "res://images/items/mugheart.png",
		"Description": "What's this doing here?"
		},	
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Move MouseRay to mouse location
	mouse_ray.position = get_global_mouse_position()
	mouse_ray.target_position = Vector2(0.0,0.0)



#func _input():
	#pass


## --------------------------------- INVENTORY CONTROLS -------------------------------------
func add_item_to_inv(item_name: String):
	inventory[item_name] = items_list[item_name]
	inventory[item_name]["Name"] = items_list[item_name]["Name"]
	inventory[item_name]["Scene"] = items_list[item_name]["Scene"]
	inventory[item_name]["Image"] = items_list[item_name]["Image"]
	inventory[item_name]["Description"] = items_list[item_name]["Description"]
	inventorynode.resetinventorygrid()
	inventory_test.refreshinventorytest()

func remove_item_from_inv(item_name: String):
	inventory.erase(item_name)
	inventorynode.resetinventorygrid()
	inventory_test.refreshinventorytest()

## Inventory adjustment test button controls
func _on_button_remove_bip_soda_pressed() -> void:
	remove_item_from_inv("Bip")
func _on_button_add_plopcorn_pressed() -> void:
	add_item_to_inv("Plopcorn")
func _on_button_add_bip_soda_pressed() -> void:
	add_item_to_inv("Bip")
func _on_button_remove_plopcorn_pressed() -> void:
	remove_item_from_inv("Plopcorn")
