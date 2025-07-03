extends ParallaxBackground

@export var scroll_speed = 100.0
var texture_height: float
var scrolling_enabled = true

func _ready():
	var sprite = $ParallaxLayer/Sprite2D
	texture_height = sprite.region_rect.size.y

func _process(delta):
	if scrolling_enabled:
		scroll_base_offset.y += scroll_speed * delta
		if scroll_base_offset.y >= texture_height:
			scroll_base_offset.y -= texture_height

func stop_scrolling():
	scrolling_enabled = false

func start_scrolling():
	scrolling_enabled = true
