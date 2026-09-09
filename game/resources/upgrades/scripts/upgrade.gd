extends Resource
class_name UpgradeBase

enum Group {
	CLICKER
}

@export var id: String
@export var display_name: String
@export var description: String
@export var group: Group = Group.CLICKER
@export var levels: Array[UpgradeEffect]
