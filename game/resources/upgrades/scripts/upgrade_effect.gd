extends Resource
class_name UpgradeEffect

enum Operation {
	ADD,
	SUBTRACT,
	MULTIPLY,
	DIVIDE,
	SET
}

@export var display_name: String
@export var description: String
@export var cost: float = 0.0
@export var operation: Operation = Operation.ADD
@export var target: String
@export var value: float
