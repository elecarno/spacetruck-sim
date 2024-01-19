extends reactor

# static
var s_output_threshold: int = 100 # °C, temp required to begin producing electricity
var s_max_coolant: int = 250 # L

# dynamic
var d_coolant: float = 0 # L

# mechanism
var m_coolant_pumps: bool = false
var m_cycle_pumps: bool = false
var m_fuel_loaders: bool = false
var m_generator: bool = false
var m_control_rods: float = 0.0

# interface elements
@onready var display_temp: Label = get_node("temp")
@onready var display_output: Label = get_node("output")
@onready var display_coolant: Label = get_node("coolant")
@onready var toggle_coolant_pump: Button = get_node("coolant_pump")
@onready var toggle_cycle_pump: Button = get_node("cycle_pump")
@onready var toggle_fuel_loader: Button = get_node("fuel_loader")
@onready var toggle_generator: Button = get_node("generator")
@onready var slider_control_rod: Slider = get_node("control_rod_slider")
@onready var status_coolant_pump: Label = get_node("coolant_pump/status")
@onready var status_cycle_pump: Label = get_node("cycle_pump/status")
@onready var status_fuel_loader: Label = get_node("fuel_loader/status")
@onready var status_generator: Label = get_node("generator/status")

func _ready():
	s_battery_capacity = 25 # kWh
	d_battery = s_battery_capacity
	d_coolant = s_max_coolant
	s_max_output = 250000 # kW
	s_max_temp = 680 # °C

func _physics_process(delta):
	# mechanics
	m_control_rods = slider_control_rod.value / 100
	
	if m_cycle_pumps and m_generator:
		d_output = calc_ouput(d_temp)
	
	if d_temp < 0:
		d_temp = 0
	
	if m_coolant_pumps:
		d_coolant -= 0.05 * delta
	
	if m_fuel_loaders:
		if m_control_rods < 0.5:
			if m_coolant_pumps:
				d_temp += 10 * delta # low rod & coolant
			else:
				d_temp += 25 * delta # low, no coolant
		elif m_control_rods >= 0.5 and m_control_rods < 0.95:
			if m_coolant_pumps:
				d_temp -= 5 * delta # high rod & coolant
			else:
				d_temp += 15 * delta # high rod, no coolant
		elif m_control_rods >= 0.95:
			if m_coolant_pumps:
				d_temp -= 0.25 * delta # full rod & coolant
			else:
				d_temp += 10 * delta # full rod, no coolant
		else:
			if m_control_rods < 0.95:
				d_temp += 35 * delta
	
	# interface
	display_temp.text = "Temp: %0000d°C" % [d_temp]
	display_output.text = "Output: %000dMW" % [d_output/1000]
	display_coolant.text = "Coolant: %000.1fL" % [d_coolant]
	
	get_node("control_rod_slider/control_rod_label").text = "Control Rods: " + str(m_control_rods*100) + "%"
	
	if d_temp > s_max_temp:
		display_temp.text = "temp: xxxx°C"
		display_output.text = "output: xxxMW"
	
func calc_ouput(t: int):
	var out: float
	if d_temp < s_output_threshold:
		return 0
	if d_temp < 370 and d_temp >= s_output_threshold:
		out = ((244109*pow(t,4))/1679241375000)-((8644747*pow(t,3))/47978325000)+((23543617*pow(t,2))/353524500)-((75134536*t)/9595665)+(1265834180/4477977)
		return out*1000
	else:
		out = ((0.00357044*pow(t,2))-(3.4909*t)+902.84)
		return out*1000

func _on_coolant_pump_pressed():
	if m_coolant_pumps:
		status_coolant_pump.text = text_deac
		toggle_coolant_pump.disabled = true
		await wait(1)
		toggle_coolant_pump.disabled = false
		m_coolant_pumps = false
		status_coolant_pump.text = text_off
	else:
		status_coolant_pump.text = text_init
		toggle_coolant_pump.disabled = true
		await wait(1)
		toggle_coolant_pump.disabled = false
		m_coolant_pumps = true
		status_coolant_pump.text = text_op

func _on_cycle_pump_pressed():
	if m_cycle_pumps:
		status_cycle_pump.text = text_deac
		toggle_cycle_pump.disabled = true
		await wait(1)
		toggle_cycle_pump.disabled = false
		m_cycle_pumps = false
		status_cycle_pump.text = text_off
	else:
		status_cycle_pump.text = text_init
		toggle_cycle_pump.disabled = true
		await wait(1)
		toggle_cycle_pump.disabled = false
		m_cycle_pumps = true
		status_cycle_pump.text = text_op

func _on_fuel_loader_pressed():
	if m_fuel_loaders:
		status_fuel_loader.text = text_deac
		toggle_fuel_loader.disabled = true
		await wait(1)
		toggle_fuel_loader.disabled = false
		m_fuel_loaders = false
		status_fuel_loader.text = text_off
	else:
		status_fuel_loader.text = text_init
		toggle_fuel_loader.disabled = true
		await wait(1)
		toggle_fuel_loader.disabled = false
		m_fuel_loaders = true
		status_fuel_loader.text = text_op


func _on_generator_pressed():
	if m_generator:
		status_generator.text = text_deac
		toggle_generator.disabled = true
		await wait(1)
		toggle_generator.disabled = false
		m_generator = false
		status_generator.text = text_off
	else:
		status_generator.text = text_init
		toggle_generator.disabled = true
		await wait(1)
		toggle_generator.disabled = false
		m_generator = true
		status_generator.text = text_op
