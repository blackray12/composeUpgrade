# toolbar button init functions
setButtonImg = (button, imgName, func1, isInstant, func2) ->
	button.subLayers[0].image = "images/buttonImages/#{imgName}.png"
	if isInstant
		button.on Events.MouseDown, -> button.subLayers[0].image = "images/buttonImages/#{imgName}_highlighted.png"
		button.on Events.MouseUp, -> 
			button.subLayers[0].image = "images/buttonImages/#{imgName}.png"
			func1()
		button.on Events.MouseOut, -> button.subLayers[0].image = "images/buttonImages/#{imgName}.png"
	
	else
		button.touchStat = 0
		button.reset = ()->
			button.touchStat = 0
			button.subLayers[0].image = "images/buttonImages/#{imgName}.png"
		button.on Events.MouseDown, -> 
			if button.touchStat == 0
				button.subLayers[0].image = "images/buttonImages/#{imgName}_highlighted.png"
			else
				button.subLayers[0].image = "images/buttonImages/key_highlighted.png"
		button.on Events.MouseUp, ->
			if button.touchStat == 0
				button.subLayers[0].image = "images/buttonImages/key.png"
				func1()
				button.touchStat = 1
			else
				button.subLayers[0].image = "images/buttonImages/#{imgName}.png"
				func2()
				button.touchStat = 0
		button.on Events.MouseOut, ->
			if button.touchStat == 0
				button.subLayers[0].image = "images/buttonImages/#{imgName}.png"
			else
				button.subLayers[0].image = "images/buttonImages/key.png"

# toolbar control
disableToolBar = ()->
	for layers in toolBar.subLayers
		layers.ignoreEvents = true

enableToolBar = ()->
	for layers in toolBar.subLayers
		layers.ignoreEvents = false

# toolbar functions

# picture touched
pictureTouched = () ->
	picShow()
# at touched	
atTouched = () ->

# topic touched
topicTouched = () ->
	
# emoji selected
emojiSelected = () ->
	toolBarButton4.reset()
	
# emoji unselected
emojiUnselceted = () ->

# plus selected
plusSelected = () ->
	toolBarButton3.reset()
	
# plus unselected
plusUnselceted = () ->

# picture init functions
picButtonPosInit = (pic) ->
	picHalfScrollViewContent.on "change:x", ->
		exposeWidth = pictureHalf.width - (picHalfScrollViewContent.x + halfPics.x + pic.x)
		if pic.width >= exposeWidth >= pic.subLayers[0].width + 4
			pic.subLayers[0].x = pictureHalf.width - picHalfScrollViewContent.x - halfPics.x - pic.x - pic.subLayers[0].width - 2
		else if exposeWidth < pic.subLayers[0].width + 4
			pic.subLayers[0].x = 2
		else if exposeWidth >= pic.width
			pic.subLayers[0].x = pic.width - pic.subLayers[0].width - 2

picButtonInit = (pic) ->
	pic.subLayers[0].isChecked = false
	pic.subLayers[0].image = "images/picButtons/uncheck.png"
	pic.subLayers[0].on Events.Click, ->
		if this.isChecked
			this.image = "images/picButtons/uncheck.png"
			this.isChecked = false
		else
			this.image = "images/picButtons/check.png"
			this.isChecked = true
	pic.reset = () ->
		pic.subLayers[0].image = "images/picButtons/uncheck.png"

picInit = (pic, i) ->
	pic.image = "images/pictures/#{i}.jpg"

# pic animations
picAnimation =
	curve: Spring(damping: 1) 
	time: .5

picHalfTitle.states = 
	show:
		y: 0
		opacity: 1
		animationOptions: picAnimation

	vanish:
		y: pictureHalf.height
		opacity: 0
		animationOptions: picAnimation

picHalfScrollView.states = 
	show:
		y: picHalfTitle.height
		opacity: 1
		animationOptions: picAnimation

	vanish:
		y: pictureHalf.height + picHalfTitle.height
		opacity: 0
		animationOptions: picAnimation

# picture control
picButtonReset = () ->
	for layers in halfPics.subLayers
		layers.reset()

picVanish = () ->
	picHalfTitle.animate("vanish")
	picHalfScrollView.animate("vanish")
	pictureHalf.backgroundColor = "transparent"
	enableToolBar()

picShow = () ->
	picButtonReset()
	picHalfTitle.animate("show")
	picHalfScrollView.animate("show")
	pictureHalf.backgroundColor = "f6f6f6"
	disableToolBar()

picReset = () ->
	picHalfTitle.stateSwitch("vanish")
	picHalfScrollView.stateSwitch("vanish")
	pictureHalf.backgroundColor = "transparent"
	enableToolBar()

#toolbar init
setButtonImg(toolBarButton0, "picture", pictureTouched, true)
setButtonImg(toolBarButton1, "at", atTouched, true)
setButtonImg(toolBarButton2, "topic", topicTouched, true)
setButtonImg(toolBarButton3, "emoji", emojiSelected, false, emojiUnselceted)
setButtonImg(toolBarButton4, "plus", plusSelected, false, plusUnselceted)

#picture init
picHalfScrollViewContent.draggable.enabled = true
picHalfScrollViewContent.draggable.speedY = 0
picHalfScrollViewContent.draggable.constraints = 
	x: picHalfScrollViewContent.superLayer.width - picHalfScrollViewContent.width
	y: 0
	width: (picHalfScrollViewContent.width - picHalfScrollViewContent.superLayer.width) + picHalfScrollViewContent.width
	height: 0
pici = 0

for layers in halfPics.subLayers
	picInit(layers, pici)
	pici++
	picButtonInit(layers)
	picButtonPosInit(layers)

finshButton.on Events.Click, ->
	picVanish()

picReset()
