class_name Action
extends Resource

enum AxisValue { positive = 1, negative = -1 }

export(String) var name: String
export(bool) var is_axis: bool = false
export(AxisValue) var axis_value: int
export(Resource) var default_values: Resource
