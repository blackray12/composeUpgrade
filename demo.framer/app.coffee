# 基础信息

# all data here

# location info
locInfo = [['北京','6093.3万'],['新浪总部大厦','10.3万'],['新浪食堂','0'],['百度科技园','103.6万'],['杨国福','109'],['达美乐','500']]

# default ranges
defaultRanges = ['公开', '好友圈', '仅自己可见']

# 范围列表可选元素
circleCheckableButtons = [0, 1, 2, 4, 5]


#设备适配

# device logic here
if Screen.height == 812 || Framer.Device.Type == "apple-iphone-x-space-gray" || Framer.Device.Type == "apple-iphone-x-silver"
	locationHalf.height = 333
	locationScrollViewContent.height += 20
	pictureHalf.height = 333
	circleHalf.height = 333
	circleScrollViewContent.height += 20
	toolBar.y = Screen.height - 333
	locationRange.y = Screen.height - locationRange.height - 333
	navigtionBarX.visible = true
	navigationBar.visible = false
else
	navigtionBarX.visible = false


# 动画、状态

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

# loc scroll content init function

locationScrollViewContent.on Events.DragStart, ->
	locationScrollViewContent.clickStat = false

setLocScrollContent = (layer, location, quantity) ->
	layer.subLayers[0].text = location
	layer.subLayers[1].text = "#{quantity}人去过·#{location}"
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

# 使 toolbar 所有按钮事件失效
disableToolBar = ()->
	for layers in toolBar.subLayers
		layers.ignoreEvents = true

# 使 toolbar 所有按钮事件生效
enableToolBar = ()->
	for layers in toolBar.subLayers
		layers.ignoreEvents = false

# picture control

# 初始化图片面板 scrollview 位置
picPositionReset = () ->
	picHalfScrollViewContent.x = 0

# 初始化图片 checkbox
picButtonReset = () ->
	for layers in halfPics.subLayers
		layers.reset()

# 图片面板动画消失
picVanish = () ->
	picHalfTitle.animate("vanish")
	picHalfScrollView.animate("vanish")
	pictureHalf.backgroundColor = "transparent"
	enableToolBar()

# 图片面板动画出现
picShow = () ->
	picPositionReset()
	picButtonReset()
	picHalfTitle.animate("show")
	picHalfScrollView.animate("show")
	pictureHalf.backgroundColor = "f6f6f6"
	disableToolBar()

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

# 地理位置面板动画出现
locShow = () ->
	locPositionReset()
	locationButtonBg.ignoreEvents = true
	locationTitle.animate("show")
	locationScrollView.animate("show")
	locationHalf.backgroundColor = "f6f6f6"
	locationScrollView.backgroundColor = "ffffff"
	disableToolBar()

# 地理位置面板初始化
locReset = () ->
	locationButtonBg.ignoreEvents = false
	locationTitle.stateSwitch("vanish")
	locationScrollView.stateSwitch("vanish")
	locationHalf.backgroundColor = "transparent"
	locationScrollView.backgroundColor = "transparent"
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

picFinishButton.on Events.Click, ->
	picVanish()

picReset()

# location init
locationScrollView.clip = true
locationScrollViewContent.draggable.enabled = true
locationScrollViewContent.draggable.speedX = 0
locationScrollViewContent.draggable.constraints = {
	x: 0
	y: locationScrollViewContent.superLayer.height - locationScrollViewContent.height
	width: 0
	height: (locationScrollViewContent.height - locationScrollViewContent.superLayer.height) + locationScrollViewContent.height
}

locReset()

locSearchButton.on Events.Click, ->


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
	locShow()
	circleVanish()

rangeButton.on Events.Click, ->
	circleShow()
	locVanish()
