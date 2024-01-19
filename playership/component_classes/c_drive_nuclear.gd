extends drive

# static
var s_max_h2: int = 1500 # L

# dynamic
var d_h2: float # L, liquid hydrogen

# mechanism

# interface elements

func _ready():
	d_h2 = s_max_h2
