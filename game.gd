extends Node2D

## Hello, Github, it's me
@onready var world: Area2D = %World
@onready var player = get_node("/root/Game/World/Player")

@onready var inventory_grid = get_node("/root/Game/ScreenControl/TrayBoxC-LEFT/TrayHBoxContainerL/InventoryGrid")
@onready var inventory_test: RichTextLabel = %InventoryTest
@onready var mouse_ray: RayCast2D = %MouseRay
@onready var screen_control: Control = %ScreenControl

@onready var _verb_grid: GridContainer = %VerbGrid
@onready var button_look: TextureButton = %ButtonLOOK
@onready var button_use: TextureButton = %ButtonUSE
@onready var button_take: TextureButton = %ButtonTAKE
@onready var button_talk: TextureButton = %ButtonTALK

@onready var button_remove_plopcorn: Button = %ButtonRemovePlopcorn
@onready var button_remove_bip_soda: Button = %ButtonRemoveBipSoda
@onready var button_add_plopcorn: Button = %ButtonAddPlopcorn
@onready var button_add_bip_soda: Button = %ButtonAddBipSoda

static var active_verb : int = 0
# 0 = Default, 1 = LOOK AT, 2 = USE, 3 = TAKE, 4 = TALK TO

static var mouse_target : Node # What node the mouse is currently over
static var items_list := {
	# Key - The item's script-facing name
		# Name - The item's player-facing name
		# Scene - What scene does this item use
		# Image - What image is used for the item
		# Description - What the PC says looking at it
		# Use-able - Can the item by used?
		# Use Line - What the PC says on trying to use it
		# Take-able - Can the item be taken and added to the inventory?
		# Take Line - What the PC says on taking the item
		# Gives - What item, if any, the world-item gives on Take.
		# Quantity - How any items it can give before disappearing
		# Enough Line - What the PC says if they already have this thing
		# Talk-able - Can you begin a dialogue with the item?
		# Talk Line - What the PC says trying to talk to it (instead of a dialogue)
	"Bip": {"Name": "Bip Soda",
		"Scene": "res://scenes/inv_items/inv_bip_soda.tscn",
		"Image": "res://images/items/bip_soda.png",
		"Description": "32oz of delicious Bip!\nMmmmm, rat blood flavour",
		"Use-able": false,
		"Use Line": "Uhhh, how do I use that?",
		"Take-able": true,
		"Take Line": "Ooh, frosty! I'll just take this!",
		"Gives": "Bip",
		"Quantity": 1,
		"Enough Line": "I don't need any more of that.",
		"Talk-able": false,
		"Talk Line": "Hi!",
		},
	"Plopcorn": {"Name": "Tub of Plopcorn",
		"Scene": "res://scenes/inv_items/inv_plopcorn.tscn",
		"Image": "res://images/items/plopcorn.png",
		"Description": "A big tub of fresh-ish plopcorn,\ncovered in goop",
		"Use-able": false,
		"Use Line": "Uhhh, how do I use that?",
		"Take-able": true,
		"Take Line": "My favourite and I AM getting snacky.",
		"Gives": "Plopcorn",
		"Quantity": 1,
		"Enough Line": "I don't need any more of that.",
		"Talk-able": false,
		"Talk Line": "Hi!",
		},
	"MugLove": {"Name": "Heart Mug",
		"Scene": "res://scenes/inv_items/inv_mug_love.tscn",
		"Image": "res://images/items/mugheart.png",
		"Description": "What's this doing here?",
		"Use-able": false,
		"Use Line": "Uhhh, how do I use that?",
		"Take-able": false,
		"Take Line": "I don't want this.",
		"Gives": "",
		"Quantity": 0,
		"Enough Line": "I don't need any more of that.",
		"Talk-able": false,
		"Talk Line": "Hi!",
		},
	"Srench": {"Name": "Srench",
		"Scene": "res://player.tscn",
		"Image": "res://images/characters/spr_srench_glow_large.png",
		"Description": "It looks oily. And bitey!",
		"Use-able": false,
		"Use Line": "Uhhh, how do I use that?",
		"Take-able": false,
		"Take Line": "I don't think it wants to go with me!",
		"Gives": "",
		"Quantity": 0,
		"Enough Line": "I don't need any more of that.",
		"Talk-able": false,
		"Talk Line": "Hi!",
		},
	"Trash": {"Name": "Trash",
		"Scene": "res://scenes/inv_items/inv_trash.tscn",
		"Image": "res://images/items/Trash.png",
		"Description": "It stinks so good!",
		"Use-able": false,
		"Use Line": "Uhhh, how do I use that?",
		"Take-able": false,
		"Take Line": "I don't think it wants to go with me!",
		"Gives": "",
		"Quantity": 0,
		"Enough Line": "I don't need any more of that.",
		"Talk-able": false,
		"Talk Line": "Hi!",
		},
	"TrashCan": {"Name": "Trash Can",
		"Scene": "res://scenes/world_items/TrashCan.tscn",
		"Image": "res://images/items/TrashCan.png",
		"Description": "It's overflowing.",
		"Use-able": false,
		"Use Line": "Uhhh, how do I use that?",
		"Take-able": true,
		"Take Line": "I'll just take a handful.",
		"Gives": "Trash",
		"Quantity": 99,
		"Enough Line": "I already have some trash!",
		"Talk-able": false,
		"Talk Line": "Hi!",
		},
	"Nothing": {}
}
static var inventory = ["MugLove"]

var _target_string : String # That node as a string
var _trim_length : int # The point in that string that begins the UID stuff
var _target_trim : String # The short, human-readable name of what the mouse is over. Should be the same as in items_list key
var _examine_target : String # Examine variant of targettrim
var _interact_timeout : bool = 0 # Is interacting on timeout?
var _examine_timeout_time : float = 0.5 # How long in seconds before the player can examine a new object

const _border_x : float = 64 # Popup borders on the left and right, px
const _border_y : float = 64 # Popup borders on the top and bottom, px
var _popup_time : float = 1.5 # How long a popup stays on screen for
var _popup_timeout : bool = 0 # Is the popup command on timeout, to prevent spamming
var _popup_timeout_length : float = 0.5 # How long in seconds the timeout lasts

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


## --------------------------------- INVENTORY CONTROLS -------------------------------------
func _inventory_add_item(item_name: String):
	if item_name not in inventory: 
		inventory.append(item_name)
		inventory_grid.add(item_name)
		#inventory_test.inventory_refresh_test()

func _inventory_remove_item(item_name: String):
	if item_name in inventory: 
		inventory.erase(item_name)
		inventory_grid.remove(item_name)
		#inventory_test.inventory_refresh_test()


## --------------------------------- INTERACTION SYSTEMS -------------------------------------
## Verb Button inputs
func _on_button_look_toggled(toggled_on: bool) -> void:
	if active_verb != 1:
		active_verb = 1
	else: active_verb = 0
func _on_button_use_toggled(toggled_on: bool) -> void:
	if active_verb != 2:
		active_verb = 2
	else: active_verb = 0
func _on_button_take_toggled(toggled_on: bool) -> void:
	if active_verb != 3:
		active_verb = 3
	else: active_verb = 0
func _on_button_talk_toggled(toggled_on: bool) -> void:
	if active_verb != 4:
		active_verb = 4
	else: active_verb = 0


## Get a popup with the target's description, if it is a valid target
func _popup(content):
	_popup_timeout = true
	get_tree().create_timer(_popup_timeout_length).timeout.connect(func(): _popup_timeout = false)
	var popup = preload("res://scenes/text_bubble.tscn")
	var instance = popup.instantiate()
	instance.text = content
	add_child(instance)
	var half_x = instance.size.x/2
	var half_y = instance.size.y/2
	instance.global_position = get_global_mouse_position() + Vector2 (-half_x,-92)
		
	# Keep popup within screen area
	if instance.global_position.x < _border_x:
		instance.global_position.x = _border_x
	elif instance.global_position.x + instance.size.x > (1920 - _border_x):
		instance.global_position.x = (1920 - _border_x) - instance.size.x
	if instance.global_position.y - instance.size.y < _border_y:
		instance.global_position.y = _border_y/2 + half_y
	elif instance.global_position.y + half_y > 952.0:
		instance.global_position.y = (1080 - _border_y) - instance.size.y
	
	# Wait popuptime seconds then remove the popup
	get_tree().create_timer(_popup_time).timeout.connect(func (): remove_child(instance))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Move MouseRay to mouse location
	mouse_ray.position = get_global_mouse_position()
	mouse_ray.target_position = Vector2(0.0,0.0)
	
	# Get mouse target's name as a string, trimmed of its UID
	mouse_target = mouse_ray.get_collider()
	if mouse_target != null:
		_target_string = str(mouse_target)
		_trim_length = _target_string.find(":")
		_target_trim = _target_string.erase(_trim_length, 99)
	else:
		_target_trim = "Nothing"


func _input(event: InputEvent) -> void:
	# LOOK AT
	if event.is_action_pressed("rmb"):
		# Clears current verb (defaulting to moving and looking)
		active_verb = 0
		var _verbbuttons := _verb_grid.get_children()
		for x in _verbbuttons:
			x.set_pressed_no_signal(false)
		if _target_trim != "Nothing" and !_interact_timeout:
			_interact_timeout = true
			get_tree().create_timer(_examine_timeout_time).timeout.connect(func(): _interact_timeout = false)
			# Posts an items description if valid
			_examine_target = _target_trim
			var desctext : String = items_list[_examine_target]["Description"]
			_popup(desctext)
	
	if event.is_action_pressed("lmb") and active_verb == 1: 
		if _target_trim != "Nothing" and !_interact_timeout:
			_examine_target = _target_trim
			var desctext : String = items_list[_examine_target]["Description"]
			_popup(desctext)
	
	
	# USE
	if event.is_action_pressed("lmb") and active_verb == 2: 
		pass
	
	# TAKE
	if player.mouseinworld and event.is_action_pressed("lmb") and active_verb == 3 and !_interact_timeout:
		if _target_trim == "Nothing":
			_popup("There's nothing to take.")
		else:
			var givenitem: String = items_list[_target_trim]["Gives"]
		
			if inventory.has(givenitem):
				var enoughtext : String = items_list[givenitem]["Enough Line"]
				_popup(enoughtext)
			
			elif _target_trim != "Nothing" and items_list[_target_trim]["Take-able"]:
				_interact_timeout = true
				get_tree().create_timer(_examine_timeout_time).timeout.connect(func(): _interact_timeout = false)
				# Add the item it gives to the inventory, and say the Takeline
				var getitem = items_list[_target_trim]["Gives"]
				_inventory_add_item(getitem)
			
				print("Taking the ", _target_trim)
				var taketext : String = items_list[_target_trim]["Take Line"]
				_popup(taketext)
			
				items_list[_target_trim]["Quantity"] -= 1
				if items_list[_target_trim]["Quantity"] == 0:
					mouse_target.visible = false
		
		
			elif _target_trim != "Nothing" and items_list[_target_trim]["Take-able"] == false:
				_interact_timeout = true
				get_tree().create_timer(_examine_timeout_time).timeout.connect(func(): _interact_timeout = false)
				# Just say the (attempting to) Take Line
				var taketext : String = items_list[_target_trim]["Take Line"]
				_popup(taketext)
			elif _target_trim == "Nothing":
					pass # Ignore input
	
	# TALK TO
	if event.is_action_pressed("lmb") and active_verb == 4:
		pass


## --------------------------------- TESTING SYSTEMS -------------------------------------

## Inventory adjustment test button controls
func _on_button_remove_plopcorn_pressed() -> void:
	if inventory.has("Plopcorn"):
		_inventory_remove_item("Plopcorn")
		items_list["Plopcorn"]["Quantity"] += 1
		world.plopcorn.visible = true
func _on_button_remove_bip_soda_pressed() -> void:
	if inventory.has("Bip"):
		_inventory_remove_item("Bip")
		items_list["Bip"]["Quantity"] += 1
		world.bip.visible = true
func _on_button_add_plopcorn_pressed() -> void:
	if !(inventory.has("Bip")):
		_inventory_add_item("Plopcorn")
		items_list["Plopcorn"]["Quantity"] -= 1
		world.plopcorn.visible = false
func _on_button_add_bip_soda_pressed() -> void:
	if !(inventory.has("Bip")):
		_inventory_add_item("Bip")
		items_list["Bip"]["Quantity"] -= 1
		world.bip.visible = false
