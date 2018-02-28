# 基础信息

# all data here

# location info
locInfo = [['北京','6093.3万'],['新浪总部大厦','10.3万'],['新浪食堂','0'],['百度科技园','103.6万'],['杨国福','109'],['达美乐','500']]
# default ranges
defaultRanges = ['公开', '好友圈', '仅自己可见']

# 范围列表可选元素
circleCheckableButtons = [0, 1, 2, 4, 5]

# plus 按钮内功能
plusData = ['头条文章', '股票', '商品']

# get the state of the NameList
NameListState = 0
SendButton.opacity = 0
Screen.backgroundColor = 'white'

Sent.center()
for layer in [SendButton, SendFor8]
	layer.onClick ->
		Sent.animate
			opacity: 1
		screenA.animate
			y: Screen.height
		input.value = ""
		Utils.delay 2, ->
			Sent.animate
				opacity: 0
			Utils.delay .3, ->
				screenA.animate
					y: 0



faketouch.onClick ->
faketouchForList.onClick ->
faketouchForList.propagateEvents = false
faketouch.propagateEvents = false
CallKeyboard.onClick -> showKeyboard()

#设备适配

# device logic
SpaceForiPhoneX = 0
TopSpaceForiPhoneX = 0
SpaceForRange = 0
iPhoneXStatuBar.opacity = 0
SpaceForStikyHeader = 0
SentFor8.opacity = 0
SendFor8.opacity = 0
if Screen.height == 812
	emotion.height = 332
	emotionTab.y -= 34
	selectors.y -= 40
	emotionPics.height = 168
	emotionPics.y += 8
	
	plus.height = 332
	plusArea.height = plus.height - 34

	SpaceForRange = 32
	locationHalf.height = 376
	circleHalf.height = 376
	pictureHalf.height = 376
	locationScrollViewContent.height += 20
	circleScrollViewContent.height += 20
	
	keyboard.y = Screen.height - 291
	SpaceForiPhoneX = 75
	TopSpaceForiPhoneX = 22
	iPhoneXStatuBar.opacity = 1
	bg.y += TopSpaceForiPhoneX

	toolBar.y = Screen.height - 376
	locationRange.y = Screen.height - locationRange.height - 333 - 42
	SpaceForStikyHeader = 13
	TopicList.height -= 30
	SearchResult.height -= 30
	NameList.height -= 30
	SentFor8.sendToBack()
	SendFor8.sendToBack()
	SendButton.bringToFront()
else
	SendButton.y = -100
	SendFor8.opacity = 1
SearchResult.y += TopSpaceForiPhoneX


if Screen.width == 414
	keyboardRatio = 414/375
	keyboard.scaleX = keyboardRatio
	SendFor8.y += 4
	SendFor8.x -= 1
	SentFor8.y += 4
	SentFor8.x -= 1
	
# InputLayer Settings / Default animation
{InputLayer} = require "input"
# Wrap input layer
input = InputLayer.wrap(bg, text, multiLine: true)

Framer.Defaults.Animation =
	time: 0.4
# 	curve: Bezier.easeInOut
	curve: Spring(damping: 1) 
# 	time: .5


Guide.parent = toolBar
Guide.center()
Guide.sendToBack()
Guide.opacity = 0

GuideTopic.parent = toolBar
GuideTopic.center()
GuideTopic.sendToBack()
GuideTopic.opacity = 0




# 动画、状态

# pic animations
picAnimation =
	Framer.Defaults.Animation

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

# circle animations
circleAnimations =
	curve: Spring(damping: 1) 
	time: .5

circleTitle.states = 
	show:
		y: 0
		opacity: 1
		animationOptions: circleAnimations

	vanish:
		y: locationHalf.height
		opacity: 0
		animationOptions: circleAnimations
		

circleScrollView.states = 
	show:
		y: locationTitle.height
		opacity: 1
		animationOptions: circleAnimations

	vanish:
		y: locationHalf.height + locationTitle.height
		opacity: 0
		animationOptions: circleAnimations

# loc animations
locAnimations =
	curve: Spring(damping: 1) 
	time: .5

locationTitle.states = 
	show:
		y: 0
		opacity: 1
		animationOptions: locAnimations

	vanish:
		y: locationHalf.height
		opacity: 0
		animationOptions: locAnimations

locationScrollView.states = 
	show:
		y: locationTitle.height
		opacity: 1
		animationOptions: locAnimations

	vanish:
		y: locationHalf.height + locationTitle.height
		opacity: 0
		animationOptions: locAnimations



#初始化用函数

# toolbar button init functions
setButtonImg = (button, imgName, func1, isInstant, func2) ->
	button.subLayers[0].image = "images/buttonImages/#{imgName}.png"
	if isInstant
		button.on Events.MouseDown, -> 
			button.subLayers[0].image = "images/buttonImages/#{imgName}_highlighted.png"
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

# circle scroll content init function

circleScrollViewContent.on Events.DragStart, ->
	circleScrollViewContent.clickStat = false

setCircleScrollContent = (layer) ->
	layer.isChecked = false
	layer.subLayers[0].image = "images/circleButtons/uncheck.png"
	layer.setUncheck = () ->
		layer.subLayers[0].image = "images/circleButtons/uncheck.png"
		layer.isChecked = false
	layer.setCheck = () ->
		layer.subLayers[0].image = "images/circleButtons/check.png"
		layer.isChecked = true
	# ignore the click event while scrolling in order not to show the keyboard unexpectedly
	return if circleScrollView.isDragging
	return if circleScrollView.isMoving
	
	layer.on Events.MouseDown, ->
		circleScrollViewContent.clickStat = true
	layer.on Events.MouseUp, ->
		if circleScrollViewContent.clickStat
			locationScrollViewContent.clickStat = false
			if this.isChecked
				circleVanish()
			else
				for i in circleCheckableButtons
					circleScrollViewContent.subLayers[i].setUncheck()
				this.setCheck()
				circleVanish()
				setRangeButtonTextIcon(this.subLayers[1].text)
		showKeyboard()

# loc scroll content init function

setLocScrollContent = (layer, location, quantity) ->
	layer.subLayers[0].text = location
	layer.subLayers[1].text = "#{quantity}人去过·#{location}"
	# ignore the click event while scrolling in order not to show the keyboard unexpectedly
	return if locationScrollView.isDragging
	return if locationScrollView.isMoving
	
	layer.on Events.MouseDown, ->
		locationScrollViewContent.clickStat = true
	layer.on Events.MouseUp, ->
		if locationScrollViewContent.clickStat
			locationScrollViewContent.clickStat = false
			locVanish()
			setLocButtonActive(location)

for i in [0...locationScrollViewContent.subLayers.length]
	setLocScrollContent(locationScrollViewContent.subLayers[i], locInfo[i][0], locInfo[i][1])


# 各模块的控制函数

# toolbar control
disableToolBar = ()->
	for layers in toolBar.subLayers
		layers.ignoreEvents = true

enableToolBar = ()->
	for layers in toolBar.subLayers
		layers.ignoreEvents = false

# picture control

# 初始化图片面板 scrollview 位置
picPositionReset = () ->
	picHalfScrollViewContent.x = 0

# 初始化图片 checkbox
picButtonReset = () ->
	originPicButton.reset()
	for layers in halfPics.subLayers
		layers.reset()
		
# 图片面板动画消失
picVanish = () ->
	picHalfTitle.animate("vanish")
	picHalfScrollView.animate("vanish")
	pictureHalf.backgroundColor = "transparent"
	enableToolBar()
	showKeyboard()

# 图片面板动画出现
picShow = () ->
	picPositionReset()
	picButtonReset()
	picHalfTitle.animate("show")
	picHalfScrollView.animate("show")
	pictureHalf.backgroundColor = "f6f6f6"
	disableToolBar()
	hideKeyboard()

# 初始化图片面板
picReset = () ->
	picHalfTitle.stateSwitch("vanish")
	picHalfScrollView.stateSwitch("vanish")
	pictureHalf.backgroundColor = "transparent"
	enableToolBar()

# circle control

# 初始化发布范围 scrollview 位置
circlePositionReset = () ->
	circleScrollViewContent.y = 0

# 发布范围面板动画消失
circleVanish = () ->
	rangeButton.ignoreEvents = false
	circleTitle.animate("vanish")
	circleScrollView.animate("vanish")
	circleHalf.backgroundColor = "transparent"
	circleScrollView.backgroundColor = "transparent"
	enableToolBar()

# 发布范围面板动画出现
circleShow = () ->
	rangeButton.ignoreEvents = true
	circlePositionReset()
	circleTitle.animate("show")
	circleScrollView.animate("show")
	circleHalf.backgroundColor = "f6f6f6"
	circleScrollView.backgroundColor = "ffffff"
	disableToolBar()


# 发布范围面板初始化
circleReset = () ->
	rangeButton.ignoreEvents = false
	circleTitle.stateSwitch("vanish")
	circleScrollView.stateSwitch("vanish")
	circleHalf.backgroundColor = "transparent"
	circleScrollView.backgroundColor = "transparent"
	enableToolBar()


# loc control

# 初始化地理位置 scrollview 位置
locPositionReset = () ->
	locationScrollViewContent.y = 0

# 地理位置面板动画消失
locVanish = () ->
	locationButtonBg.ignoreEvents = false
	locationTitle.animate("vanish")
	locationScrollView.animate("vanish")
	locationHalf.backgroundColor = "transparent"
	locationScrollView.backgroundColor = "transparent"
	enableToolBar()
	showKeyboard()

# 地理位置面板动画出现
locShow = () ->
	locPositionReset()
	locationButtonBg.ignoreEvents = true
	locationTitle.animate("show")
	locationScrollView.animate("show")
	locationHalf.backgroundColor = "f6f6f6"
	locationScrollView.backgroundColor = "ffffff"
	disableToolBar()
	hideKeyboard()

# 地理位置面板初始化
locReset = () ->
	locationButtonBg.ignoreEvents = false
	locationTitle.stateSwitch("vanish")
	locationScrollView.stateSwitch("vanish")
	locationHalf.backgroundColor = "transparent"
	locationScrollView.backgroundColor = "ffffff"
	enableToolBar()

# loc button control

# 根据输入字符串设置地理位置 button 的文字内容
setLocButtonText = (location) ->
	locationButtonText.text = location
	if locationButton.active
		newButtonWidth = locationButtonIcon.width + locationButtonText.width + locationCancelButton.width + locationButtonIcon.x + 9
	else
		newButtonWidth = locationButtonIcon.width + locationButtonText.width + locationButtonIcon.x + 9
	locationButtonBg.animate
		width: newButtonWidth
		options:
			curve: Spring(damping: 1)
			time: 0.3

# 根据输入的字符串将地理位置 button 设置成激活状态
setLocButtonActive = (location) ->
	locationCancelButton.visible = true
	locationButton.active = true
	setLocButtonText(location)
	locationButtonText.color = "#4F7DB2"
	locationButtonIcon.image = "images/locationRangeButtonImages/locBlue.png"

# 初始化地理位置 button 状态
setLocButtonNormal = () ->
	locationCancelButton.visible = false
	locationButton.active = false
	setLocButtonText("你在哪里？")
	locationButtonText.color = "#939393"
	locationButtonIcon.image = "images/locationRangeButtonImages/locGray.png"


# range button functions

# 根据输入字符串设置发布范围 button 的 icon 和文字
setRangeButtonTextIcon = (type) ->
	rangeButtonText.text = type
	newButtonWidth = rangeButtonIcon.width + rangeButtonText.width + 9 + 4
	rangeButtonBg.animate
		width: newButtonWidth
		options:
			curve: Spring(damping: 1)
			time: 0.3
	isUser = true
	for word in defaultRanges
		if type == word
			rangeButtonIcon.image = "images/rangeIcons/#{type}.png"
			isUser = false
	if isUser
		rangeButtonIcon.image = "images/rangeIcons/user.png"

# 将发布范围状态初始化
setRangeButtonNormal = () ->
	setRangeButtonTextIcon("公开")
	circleScrollViewContent.subLayers[0].setCheck()


# toolbar 事件控制

# toolbar events

# picture touched
pictureTouched = () ->
	toolBarButton3.reset()
	toolBarButton4.reset()
	emotion.opacity = 0
	plus.opacity = 0
	picShow()


# at touched
atTouched = () ->
	toolBarButton3.reset()
	toolBarButton4.reset()
	emotion.opacity = 0
	plus.opacity = 0
	input.value += "@"
	NameList.placeBefore(faketouchForList)
	NameList.animate
		opacity: 1
	NameListState = 1
	locationRange.animate
		opacity: 0
	ShowGuide()

# topic touched
topicTouched = () ->
	toolBarButton3.reset()
	toolBarButton4.reset()
	emotion.opacity = 0
	plus.opacity = 0
	input.value += "#"
	TopicList.placeBefore(faketouchForList)
	TopicList.animate
		opacity: 1
	locationRange.animate
		opacity: 0
	ShowGuideTopic()
	
# emoji selected
emojiSelected = () ->
	toolBarButton4.reset()
	emotion.opacity = 1
	plus.opacity = 0
	JustHideKeyboard()
	
# emoji unselected
emojiUnselceted = () ->
	emotion.opacity = 0
	showKeyboard()


# plus selected
plusSelected = () ->
	toolBarButton3.reset()
	plus.opacity = 1
	emotion.opacity = 0
	JustHideKeyboard()
	
# plus unselected
plusUnselceted = () ->
	plus.opacity = 0
	showKeyboard()


# 初始化

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

originPictureButtonPic.backgroundColor = "transparent"

originPicButton.reset = () ->
	originPictureButtonPic.image = "images/originpic/false.png"
	originPicButton.stat = false
	
originPicButton.reset()

originPicButton.on Events.Click, ->
	if originPicButton.stat
		originPictureButtonPic.image = "images/originpic/false.png"
		originPicButton.stat = false
	else
		originPictureButtonPic.image = "images/originpic/true.png"
		originPicButton.stat = true
	

# locationhalf init
locationScrollView.clip = true
locationScrollViewContent.draggable.enabled = true
locationScrollViewContent.draggable.speedX = 0
locationScrollViewContent.draggable.constraints = {
	x: 0
	y: locationScrollViewContent.superLayer.height - locationScrollViewContent.height
	width: 0
	height: (locationScrollViewContent.height - locationScrollViewContent.superLayer.height) + locationScrollViewContent.height
}

locationScrollViewContent.on Events.DragStart, ->
	locationScrollViewContent.clickStat = false

# circle init
circleScrollView.clip = true
circleScrollViewContent.draggable.enabled = true
circleScrollViewContent.draggable.speedX = 0
circleScrollViewContent.draggable.constraints = {
	x: 0
	y: circleScrollViewContent.superLayer.height - circleScrollViewContent.height
	width: 0
	height: (circleScrollViewContent.height - circleScrollViewContent.superLayer.height) + circleScrollViewContent.height
}

for i in circleCheckableButtons
	setCircleScrollContent(circleScrollViewContent.subLayers[i])

circleReset()

circleFinishButton.on Events.Click, ->
	circleVanish()
	showKeyboard()
	
	

# location & range button init
locationButtonBg.on "change:width", ->
	newX = locationButtonBg.width - locationCancelButton.width
	locationCancelButton.x = newX

locationCancelButton.on Events.Click, ->
	setLocButtonNormal()
	
rangeButtonBg.on "change:width", ->
	rangeButtonText.x = rangeButton.width - rangeButtonBg.width + rangeButtonIcon.width + 4 
	rangeButtonIcon.x = rangeButton.width - rangeButtonBg.width + 4

setLocButtonNormal()
setRangeButtonNormal()

locationButtonBg.on Events.Click, ->
	toolBarButton3.reset()
	toolBarButton4.reset()
	emotion.opacity = 0
	plus.opacity = 0
	locShow()
	circleVanish()
	
rangeButton.on Events.Click, ->
	toolBarButton3.reset()
	toolBarButton4.reset()
	emotion.opacity = 0
	plus.opacity = 0
	circleShow()
	locVanish()
	hideKeyboard()


#emotion init
emotion.opacity = 0

for i in [0...emotionPics.subLayers.length - 1]
	emotionPics.subLayers[i].image = "images/emotionpic/#{i}.png"

# plus init
plus.opactity = 0

for i in [0...plusButtons.subLayers.length]
	if i < plusData.length
		plusButtons.subLayers[i].subLayers[1].text = plusData[i]
		plusButtons.subLayers[i].subLayers[0].backgroundColor = "transparent"
		plusButtons.subLayers[i].subLayers[0].image = "images/plusButtons/#{i}.png"
	else
		plusButtons.subLayers[i].visible = false


picReset()
locReset()
setLocButtonNormal()


# NameList State Settings
ShowGuide = ->
	Guide.bringToFront()
	Utils.delay 0.1, ->
		Guide.animate
			opacity: 1
			
HideGuide = ->
	Guide.animate
		opacity: 0
	Utils.delay 0.1, ->
		Guide.sendToBack()
		
NameListOn = ->
	NameList.placeBehind(keyboard)
	NameList.animate
		opacity: 1
		options: 
			time: .1
			curve: Bezier.easeInOut
	NameListState = 1
	ShowGuide()


	
NameListOff = ->
	NameList.animate
		opacity: 0
		options: 
			time: .1
			curve: Bezier.easeInOut
	Utils.delay .2, ->
		NameList.sendToBack()
		showAll()
		Resetkeyboard()
		NameListView.scrollY = 0
	NameListState = 0
	locationRange.animate
		opacity: 1
	HideGuide()


# Keyboard Simulator
# Variables
lettersActive = true 
numbersActive = false
showLeftKey = false 
showRightKey = false
showLargeKey = false
input.readonly = true

# Methods 		
## Show active key
showActiveKey = (key, showLeftKey, showRightKey) ->

	offsetX = 2 
	offsetY = 3
	
	currentActiveKey = activeKey
	currentActiveLetter = activeLetter
	
	if showLeftKey
		currentActiveKey = activeKeyLeft
		currentActiveLetter = activeLetterLeft
		offsetX = -19
		
	else if showRightKey
		currentActiveKey = activeKeyRight
		currentActiveLetter = activeLetterRight
		offsetX = 11
		
	else if showLargeKey
		currentActiveKey = activeKeyLarge
		currentActiveLetter = activeLetterLarge
		offsetX = -8
		
	currentActiveKey.opacity = 1
	currentActiveKey.point = 
		x: key.x - (key.width / 2) - 5 - offsetX
		y: key.y - currentActiveKey.height + key.height + offsetY
		
	if lettersActive
		currentActiveKey.parent = keyboard
		currentActiveLetter.text = key.name
	
	if numbersActive
		currentActiveKey.parent = numeric 
		currentActiveLetter.text = key.name
		currentActiveLetter.x = Align.center
	
	if shiftIconActive.visible
		currentActiveLetter.textTransform = "uppercase"			
	else
		currentActiveLetter.textTransform = "lowercase"
	ValueLength = input.value.length
	ListsRelocation = Math.round(ValueLength/70)
	
## Map all keys
mapLetterKeys = (e) ->	
	for key in letters.children
		name = String.fromCharCode(e.which) 
		
		if key.name is name
		
			if name is "q"
				showLeftKey = true
				showRightKey = false
			if name is "p"
				showLeftKey = false 
				showRightKey = true 
			
			showActiveKey(key, showLeftKey, showRightKey, showLargeKey)			

mapNumberKeys = (e) ->	
	for key in numbers.children
		name = String.fromCharCode(e.which) 
		
		if key.name is name
					
			if name is "1" or name is "-"
				showLeftKey = true
				showRightKey = false
				showLargeKey = false
			if name is "0" or name is "“"
				showLeftKey = false
				showRightKey = true
				showLargeKey = false
			if name is "."
				showLeftKey = false
				showRightKey = false 
				showLargeKey = true 
		
			showActiveKey(key, showLeftKey, showRightKey, showLargeKey)		
								
## Uppercase & Lowercase
setUppercase = ->
	for key in letters.children
		key.children[0].textTransform = "uppercase"
		key.children[0].x = Align.center()
		key.children[0].y = Align.center(1)
		shiftIconActive.visible = true
		shiftIcon.visible = false
		
setLowercase = ->
	for key in letters.children
		key.children[0].textTransform = "lowercase"
		key.children[0].x = Align.center()
		key.children[0].y = Align.center(-1)
		shiftIconActive.visible = false
		shiftIcon.visible = true
		
checkValue = ->
	if input.value == ""
		setUppercase()
		SendButton.opacity = 0
		SentFor8.opacity = 0
	else
		setLowercase()
		SendButton.opacity = 1
		SentFor8.opacity = 1
		
# Tap interactions for letters
for key in letters.children
		
	key.onTapStart ->
		return if numbersActive
		
		showLeftKey = false 
		showRightKey = false
		showLargeKey = false
		
		if @name is "q"
			showLeftKey = true 
			showRightKey = false
			showLargeKey = false
		if @name is "p"
			showLeftKey = false 
			showRightKey = true
			showLargeKey = false
				
		showActiveKey(this, showLeftKey, showRightKey, showLargeKey)
					
	key.onTapEnd ->
		return if numbersActive

		currentActiveKey = activeKey
		currentActiveLetter = activeLetter

		if showLeftKey
			currentActiveKey = activeKeyLeft
			currentActiveLetter = activeLetterLeft
			
		else if showRightKey
			currentActiveKey = activeKeyRight
			currentActiveLetter = activeLetterRight
			
		currentActiveKey.opacity = 0
# 		input._inputElement.focus()
		
		if shiftIconActive.visible
			input.value += currentActiveLetter.text.toUpperCase()		
		else
			input.value += currentActiveLetter.text
			
		checkValue()
		input.emit(Events. ValueChange, input.value)
		if @name is "a"
			if NameListState == 1
				SearchName()
				NameListOff()
				ShowSearchResult()
				toolBar.sendToBack()

	
# Tap interactions for numbers
for key in numbers.children
		
	key.onTapStart ->
		return if lettersActive
		
		showLeftKey = false 
		showRightKey = false
		showLargeKey = false
		
		if @name is "1" or @name is "-"
			showLeftKey = true 
			showRightKey = false
			showLargeKey = false
		if @name is "0" or @name is "“"
			showLeftKey = false 
			showRightKey = true 
			showLargeKey = false
		if @name is "." or @name is "," or @name is "?" or @name is "!" or @name is "‘"
			showLeftKey = false 
			showRightKey = false 
			showLargeKey = true
				
		showActiveKey(this, showLeftKey, showRightKey, showLargeKey)
					
	key.onTapEnd ->
		return if lettersActive
		
		currentActiveKey = activeKey
		currentActiveLetter = activeLetter
		
		if showLeftKey
			currentActiveKey = activeKeyLeft
			currentActiveLetter = activeLetterLeft
			
		else if showRightKey
			currentActiveKey = activeKeyRight
			currentActiveLetter = activeLetterRight
		
		else if showLargeKey
			currentActiveKey = activeKeyLarge
			currentActiveLetter = activeLetterLarge
			
		currentActiveKey.opacity = 0
# 		input._inputElement.focus()
		input.value += currentActiveLetter.text
		input.emit(Events.InputValueChange, input.value)	
		if @name is '@'
			NameListOn()
			


# Keyboard methods	
document.onkeydown = (e) ->
	# Shift down
	if e.which == 16
		if shiftIconActive.visible
			return 
		else
			setUppercase()	
								
document.onkeypress = (e) ->
	
	if lettersActive
		mapLetterKeys(e)
		
	if numbersActive
		mapNumberKeys(e)
		
	# Space down
	if e.which == 32
		space.backgroundColor = "#ACB4BC"
	
					
document.onkeyup = (e) ->
	
	currentActiveKey = activeKey
	
	if showLeftKey
		currentActiveKey = activeKeyLeft
		
	else if showRightKey
		currentActiveKey = activeKeyRight
		
	currentActiveKey.opacity = 0
	
	# Space up
	if e.which == 32
		space.backgroundColor = "#FFFFFF"
	
	# Shift up 
	if e.which == 16
		setLowercase()
	
	checkValue()
		
# Extras
# Space
space.onTap -> input.value += " "	
space.onTapStart -> @backgroundColor = "#ACB4BC"	
space.onTapEnd -> @backgroundColor = "#FFFFFF"
input.onSpaceKey -> space.backgroundColor = "#ACB4BC"

# Return
returnKey.onTapStart -> @backgroundColor = "#FFFFFF"	
returnKey.onTapEnd -> @backgroundColor = "#ACB4BC"
returnKey.onTap ->
	if input.multiLine
		input.value += "/n"
			
# Shift			
shift.onTap ->
	if shiftIconActive.visible
		setLowercase()					
	else
		setUppercase()
		
# Caps lock
input.onCapsLockKey ->
	if shiftIconActive.visible
		setLowercase()
	else 
		setUppercase()

# Backspace
backspace.onTapStart ->
	backSpaceIcon.visible = false
	backSpaceIconActive.visible = true
	input.value = input.value.slice(0, -1)
	
backspace.onTapEnd ->
	backSpaceIcon.visible = true
	backSpaceIconActive.visible = false
	checkValue()
	NameListOff()
	HideGuideTopic()
	TopicList.animate
		opacity: 0
		options: 
			time: .1
			curve: Bezier.easeInOut
	Utils.delay .2, ->
		TopicList.sendToBack()
		
# Clear all
backspace.onLongPress ->
	input.value = ""
	
# Numbers
numbersKey.onTap (event) ->
	lettersActive = false 
	numbersActive = true

	numeric.x = 0
	numeric.y = Screen.height - numeric.height - SpaceForiPhoneX
	numeric.parent = screenA
	
lettersKey.onTap (event) ->
	Resetkeyboard()
# Reset Keyboard
Resetkeyboard = ->
	lettersActive = true 
	numbersActive = false
	numeric.x = Screen.width
# Hide on mobile
unless Utils.isDesktop()
	keyboard.opacity = 0
	numeric.opacity = 0
keyboard.onClick ->
numeric.onClick ->
keyboardExtra.onClick ->

# Keyboard Controler

toolBar.originalYPosition = toolBar.y
locationRange.originalYPosition = locationRange.y
JustHideKeyboard = ->
	keyboard.animate
		y: Screen.height
		opacity: 0
	numeric.animate
		opacity: 0
		y: Screen.height
JustShowKeyboard = ->
	keyboard.animate
		y: Screen.height - 216 - SpaceForiPhoneX
		opacity: 1
	numeric.animate
		opacity: 1
		y: Screen.height - 216 - SpaceForiPhoneX
		
JustShowKeyboard()

hideKeyboard = ->
	JustHideKeyboard()
	toolBar.animate
		opacity: 0
		y: Screen.height


showKeyboard = ->
	JustShowKeyboard()
	toolBar.animate
		opacity: 1
		y: toolBar.originalYPosition

hideAll = ->
	hideKeyboard()
	locationRange.animate
		opacity: 0
		y: Screen.height
		
showAll = ->
	showKeyboard()
	locationRange.animate
		opacity: 1
		y: locationRange.originalYPosition
	

# Names
names =['Akan', 'Arabic', 'Bulgarian', 'Czech', 'Dutch', 'England','Fijian', 'German', 'Hawaiian', 'Icelandic', 'Japanese', 'Korean', 'Lithuanian', 'Malaysian', 'Nana', 'Optimy', 'Philippine', 'Queen', 'Russian', 'Spanish', 'Taiwanese', 'Uper', 'Vietnamese','Walls', 'Xia', 'Yang', "Zeat"]

namesR = ['Daqian','Xiaohe', 'Xiaojing', 'Zhaoxi', 'Lulu']

NameResult = ['A-bowlife', 'carmendarcy','国际4A广告' ,'A酱' ,'刘大美人A' ,'霸哥a' ,'哆啦A梦']

# Name List settings
NameList.opacity = 0
NameList.sendToBack()

NameListHeight = 50
NameListDistance = 278
NameList.y += TopSpaceForiPhoneX
NameListView = new ScrollComponent
	width: NameList.width
	height: NameList.height
	parent: NameList
NameListView.backgroundColor = null
	# The scroll direction is limited to only allow for vertical 
NameListView.scrollHorizontal = false
NameListView.mouseWheelEnabled = true

# Variable which will hold all of the section headers
sectionHeaders = []
characters = " ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("")
cells = []
numberOfSections = characters.length
for sectionIndex in [0...numberOfSections]
	# We create a section header
	if sectionIndex == 0
		sectionHeader = new Layer
			y: sectionIndex * NameListDistance
			width: NameList.width, height:30
			parent: NameListView.content
			backgroundColor:"#F8F8F8"
			html: "#{characters[sectionIndex]}"
			style:
				paddingLeft:"48px", fontWeight: "250"
				lineHeight:"60px", fontSize:"17px", color: "black"
		sectionHeader.originalYPosition = sectionHeader.y
		sectionHeaders.push sectionHeader
		rowsPerSection = 5

		for rowIndex in [0...rowsPerSection]
			# A cell is created for the row
			if sectionIndex <= 0
				cell = new Layer
					name: namesR[rowIndex]#(sectionIndex + 1) * 10 + rowIndex
					x: 16
					y: rowIndex*NameListHeight
					width:NameList.width - 32, height:48
					backgroundColor:null
					style: borderBottom: "1px solid #E1E1E1"
					# The cell is put inside the content layer of the scroll component
					superLayer: NameListView.content
				cells.push(cell)
				nameAvatar = new Layer
					parent: cell
					y: Align.center
					height: 30
					width: 30
					borderRadius: 30
					borderColor: '#eee'
					borderWidth: .5
					backgroundColor: null
					image: Utils.randomImage()
				layer = new TextLayer
					text: namesR[rowIndex]
					parent: cell
					fontSize: 16, fontStyle: "PingFang SC", color: "#333", padding: top: 13,left: 40
	else
		sectionHeader = new Layer
			y: sectionIndex * NameListDistance - 30
			width: NameList.width, height:30
			parent: NameListView.content
			backgroundColor:"#F8F8F8"
			html: "#{characters[sectionIndex]}"
			style:
				paddingLeft:"48px", fontWeight: "250",paddingTop: "#{SpaceForStikyHeader}px"
				lineHeight:"60px", fontSize:"17px", color: "black"
		sectionHeader.originalYPosition = sectionHeader.y
		sectionHeaders.push sectionHeader
		rowsPerSection = 5
		for rowIndex in [0...rowsPerSection]
			if sectionIndex >= 1
				cell = new Layer
					name: names[sectionIndex]#(sectionIndex + 1) * 10 + rowIndex
					x: 16
					y: 19 + (rowIndex*NameListHeight)+(sectionIndex*NameListDistance) - 30
					width: NameList.width - 32, height:60
					backgroundColor:null
					style: borderBottom: "1px solid #E1E1E1"
					# The cell is put inside the content layer of the scroll component
					parent: NameListView.content
				nameAvatar = new Layer
					parent: cell
					y: 20
					height: 30
					width: 30
					borderRadius: 30
					borderColor: '#eee'
					borderWidth: .5
					backgroundColor: null
					image: Utils.randomImage()
				layer = new TextLayer
					text: names[sectionIndex]
					parent: cell
					fontSize: 16, fontStyle: "PingFang SC", color: "#333", padding: top:23,left: 40
				cells.push(cell)
	# 			print cell.name

SearchNameView = new ScrollComponent
	width: SearchResult.width
	height: 500
	parent: SearchResult
	backgroundColor: null
	# The scroll direction is limited to only allow for vertical 
SearchNameView.scrollHorizontal = false
SearchNameView.mouseWheelEnabled = true
SearchNameViewState = 0
SearchNameView.onScrollStart -> SearchNameViewState = 1
SearchNameView.onScrollEnd -> SearchNameViewState = 0
SearchNameView.onMove (event) ->
	yOffsetSN = -event.y
	if yOffsetSN < 1
		yOffsetStateSN = 1
	else 
		yOffsetStateSN = 0
		if SearchNameViewState = 1 && yOffsetSN > 2
			hideAll()
	if yOffsetStateSN == 1 && SearchNameViewState == 0
		showKeyboard()
		locationRange.y = locationRange.originalYPosition

SearchResult.sendToBack()

ShowSearchResult = ->
	SearchResult.placeBehind(keyboard)
	SearchResult.animate
		opacity: 1
		options: 
			time: .1
			curve: Bezier.easeInOut
			
HideSearchResult = ->
	SearchResult.animate
		opacity: 0
		options: 
			time: .1
			curve: Bezier.easeInOut
	Utils.delay 0.2, ->
		SearchResult.sendToBack()
			
SearchName = ->
	for rowIndex in [0...7]
		# A cell is created for the row
		cell = new Layer
			name: NameResult[rowIndex]#(sectionIndex + 1) * 10 + rowIndex
			x: 16
			y: rowIndex*NameListHeight
			width:NameList.width - 32, height:48
			backgroundColor:null
			style: borderBottom: "1px solid #E1E1E1"
			# The cell is put inside the content layer of the scroll component
			parent: SearchNameView.content
		cells.push(cell)
		nameAvatar = new Layer
			parent: cell
			y: Align.center
			height: 30
			width: 30
			borderRadius: 30
			borderColor: '#eee'
			borderWidth: .5
			backgroundColor: null
			image: Utils.randomImage()
		layer = new TextLayer
			text: NameResult[rowIndex]
			parent: cell
			fontSize: 16, fontStyle: "PingFang SC", color: "#333", padding: top: 13,left: 40
		searchMorePH = new Layer
			x: 16
			y: 7*NameListHeight
			width:NameList.width - 32, height:48
			backgroundColor:null
			style: borderBottom: "1px solid #E1E1E1"
			# The cell is put inside the content layer of the scroll component
			parent: SearchNameView.content
		searchMore = new TextLayer
			text: "在网络上搜索"
			parent: searchMorePH
			fontSize: 16, fontStyle: "PingFang SC", color: "#333", padding: top: 13
		searchMoreIcon.parent = SearchNameView.content
		searchMoreIcon.y = searchMorePH.y + 13
		searchMoreIcon.x = Screen.width - 25
SearchName()

# Input Names From NameList
for layer in cells
	layer.onClick ->
		return if NameListView.isDragging
		return if NameListView.isMoving
		return if SearchNameView.isDragging
		return if SearchNameView.isMoving
		input.value += @name + " "
		NameListOff()
		HideSearchResult()
		ValueLength = input.value.length
		toolBar.placeBefore(keyboard)

# Stiky header / scroll & hide
for layer in sectionHeaders
	layer.bringToFront()
sectionHeaders[0].opacity = 0
NameListView.onScrollStart -> NameListViewState = 1
NameListView.onScrollEnd -> NameListViewState = 0
NameListView.onMove (event) ->
	yOffset = -event.y
	for layer in sectionHeaders
		if yOffset > layer.originalYPosition
			if yOffset > layer.originalYPosition + NameListDistance - NameListHeight + 20
				layer.y = layer.originalYPosition + NameListDistance - NameListHeight + 20
			else
				layer.y = yOffset - 1
		else
			layer.y = layer.originalYPosition
	if yOffset < 1
		yOffsetState = 1
	else 
		yOffsetState = 0
		if NameListViewState = 1 && yOffset > 2
			hideAll()
	if yOffsetState == 1
		showKeyboard()
		locationRange.y = locationRange.originalYPosition

# Topics
topics = ['食人的大鹫', '流行','雷神3：诸神黄昏', '每日桌面', '新浪总部大厦', "鹿晗",'30天英雄联盟挑战', '周总理逝世42周年', '河间驴肉火烧造假', 'V影响力峰会', '汪峰', '陈乔恩','挑一挑攻略', '守望先锋30天挑战', '人人网遭监管约谈', '李泽言0113生日快乐', '北京', '越听越痛的歌', '北京乐派', '南方的猪第一次看见雪', '亚洲新歌榜', '我的年度金曲', '跟着墩布挖白菜', '国家最高科技奖', '最晕路口37个红绿灯', '北京租房', '老公我要这个']
tagIcon = ["images/topicIcon/movie.png","images/topicIcon/tag.png", "images/topicIcon/music.png", "images/topicIcon/loca.png"]

# Topic List settings

ShowGuideTopic = ->
	GuideTopic.bringToFront()
	Utils.delay 0.1, ->
		GuideTopic.animate
			opacity: 1
			
HideGuideTopic = ->
	GuideTopic.animate
		opacity: 0
	Utils.delay 0.1, ->
		GuideTopic.sendToBack()
	
TopicList.opacity = 0
TopicList.sendToBack()
TopicList.y += TopSpaceForiPhoneX
TopicList.ignoreEvents = true
TopicListHeight = 50
TopicListDistance = 50
TopicListView = new ScrollComponent
	width: TopicList.width
	height: TopicList.height
	parent: TopicList
TopicListView.backgroundColor = null
	# The scroll direction is limited to only allow for vertical 
TopicListView.scrollHorizontal = false
TopicListView.mouseWheelEnabled = true

# Variable which will hold all of the section headers
topiccells = []
TopicnumberOfSections = 24
for sectionIndex in [0...TopicnumberOfSections]
	# We create a section heade
# 	for rowIndex in [0...rowsPerSection]
	cell = new Layer
		name: topics[sectionIndex]#(sectionIndex + 1) * 10 + rowIndex
		x: 16
		y: (sectionIndex*TopicListDistance)
		width: TopicList.width - 16, height:60
		backgroundColor:null
		style: borderBottom: "1px solid #E1E1E1"
		# The cell is put inside the content layer of the scroll component
		parent: TopicListView.content
	icon = new Layer
		parent: cell
		width: 20
		height: 20
		borderRadius: 10
		backgroundColor: null
		x: 2
		y: 25
		image: Utils.randomChoice(tagIcon)
	layer = new TextLayer
		text: "    " + topics[sectionIndex]
		parent: cell
		fontSize: 16, fontStyle: "PingFang SC", color: "#333", padding: top:24,left: 13
	topiccells.push(cell)
# 			print cell.name

# input topic from TopicList
for layer in topiccells
	layer.onClick ->
		return if TopicListView.isDragging
		return if TopicListView.isMoving
		input.value += @name + "#" + " "
		TopicList.animate
			opacity: 0
			options: 
				time: .1
				curve: Bezier.easeInOut
		Utils.delay .2, ->
			TopicList.sendToBack()
			showAll()
			Resetkeyboard()
			TopicListView.scrollY = 0
		ValueLength = input.value.length
		HideGuideTopic()

TopicListView.onScrollStart -> TopicListViewState = 1
TopicListView.onScrollEnd -> TopicListViewState = 0
TopicListView.onMove (event) ->
	yOffsett = - event.y
	if yOffsett < 1
		yOffsetStatee = 1
	else 
		yOffsetStatee = 0
		if TopicListViewState = 1 && yOffsett > 2
			hideAll()
	if yOffsetStatee == 1
		showKeyboard()
		locationRange.y = locationRange.originalYPosition
		
bg.onClick ->
