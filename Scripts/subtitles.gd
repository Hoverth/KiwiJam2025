extends Label

@export var delay_1 = 8000
@export var delay_2 = 10000
@export var delay_3 = 15000
@export var delay_4 = 18000
@export var delay_5 = 22000
@export var delay_6 = 27000
@export var delay_7 = 32000
@export var delay_8 = 35000
@export var delay_9 = 37550
@export var delay_10 = 43300
@export var delay_11 = 46860
@export var delay_12 = 50900
@export var delay_13 = 53460
@export var delay_14 = 57480
@export var delay_15 = 60730
@export var delay_16 = 65700
@export var delay_17 = 70670
@export var delay_18 = 75120
@export var delay_19 = 77200

var start_time: int

func _ready():
	start_time = Time.get_ticks_msec()

func _process(delta):
	var t = Time.get_ticks_msec()
	if start_time + delay_1 < t:
		text = "But don't you worry, Old Sport"
	if start_time + delay_2 < t:
		text = "Your trusty Air Traffic controller will help safely guide you through this storm"
	if start_time + delay_3 < t:
		text = "It seems your Altimeter has stopped working"
	if start_time + delay_4 < t:
		text = "Luckily I slipped a GPS tracker into your back pocket"
	if start_time + delay_5 < t:
		text = "So I can see your altitude and will ensure you are flying safe"
	if start_time + delay_6 < t:
		text = "Just press W or S on your keyboard to increase or decrease your altitude"
	if start_time + delay_7 < t:
		text = "Wow! Flying has never been easier"
	if start_time + delay_8 < t:
		text = "Oh and make sure you check your cameras"
	if start_time + delay_9 < t:
		text = "Some of the parts of this are aircraft aren't exactly what you would call legal or at all airworthy"
	if start_time + delay_10 < t:
		text = "You will need to make sure everything is working properly"
	if start_time + delay_11 < t:
		text = "And if not I can reset it on my trusty leapfrog tablet"
	if start_time + delay_12 < t:
		text = "Occasionally we may need to lighten the load"
	if start_time + delay_13 < t:
		text = "And the least valuable things on this plane are the passengers"
	if start_time + delay_14 < t:
		text = "So if you see that load capacity light blinking"
	if start_time + delay_15 < t:
		text = "Make sure to tell me the colour code so I can let you know who we need to eject"
	if start_time + delay_16 < t:
		text = "And I think that's about everything so I will let you do your thing and fly the plane"
	if start_time + delay_17 < t:
		text = "Just make sure not to hit any Air Traffic Control Towers"
	if start_time + delay_18 < t:
		text = "Good Luck, Old Sport"
	if start_time + delay_19 < t:
		visible = false
