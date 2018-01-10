# all data here

# location info
locInfo = [['北京','6093.3万'],['新浪总部大厦','10.3万'],['新浪食堂','0'],['百度科技园','103.6万'],['杨国福','109'],['达美乐','500']]
SpaceForiPhoneX = 0
if Framer.Device.deviceType == 'apple-iphone-x-silver' or Framer.Device.deviceType == 'apple-iphone-x-space-gray'
	keyboard.y = Screen.height - 291
	SpaceForiPhoneX = 75
toolBar.y -= SpaceForiPhoneX
pictureHalf.y -= SpaceForiPhoneX
locationRange.y -= SpaceForiPhoneX

# InputLayer Settings / Default animation
{InputLayer} = require "input"
# Wrap input layer
input = InputLayer.wrap(bg, text, multiLine: true)

Framer.Defaults.Animation =
	time: 0.4
# 	curve: Bezier.easeInOut
	curve: Spring(damping: 1) 
# 	time: .5

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
				JustHideKeyboard()
			else
				button.subLayers[0].image = "images/buttonImages/key_highlighted.png"
				JustShowKeyboard()
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
	input.value += "@"
	NameList.placeBehind(keyboard)
	NameList.animate
		opacity: 1
				

# topic touched
topicTouched = () ->
	input.value += "#"
	TopicList.placeBehind(keyboard)
	TopicList.animate
		opacity: 1
	
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

picInit = (pic, i) ->
	pic.image = "images/pictures/#{i}.jpg"

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

# picture control
picVanish = () ->
	picHalfTitle.animate("vanish")
	picHalfScrollView.animate("vanish")
	pictureHalf.backgroundColor = "transparent"
	enableToolBar()
	showKeyboard()

picShow = () ->
	picHalfTitle.animate("show")
	picHalfScrollView.animate("show")
	pictureHalf.backgroundColor = "f6f6f6"
	disableToolBar()
	hideKeyboard()

picReset = () ->
	picHalfTitle.stateSwitch("vanish")
	picHalfScrollView.stateSwitch("vanish")
	pictureHalf.backgroundColor = "transparent"
	enableToolBar()

# loc button functions

locationButtonBg.on "change:width", ->
	newX = locationButtonBg.width - locationCancelButton.width
	locationCancelButton.x = newX

locationCancelButton.on Events.Click, ->
	setLocButtonNormal()

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

setLocButtonActive = (location) ->
	locationCancelButton.visible = true
	locationButton.active = true
	setLocButtonText(location)
	locationButtonText.color = "#4F7DB2"
	locationButtonIcon.image = "images/locationRangeButtonImages/locBlue.png"

setLocButtonNormal = () ->
	locationCancelButton.visible = false
	locationButton.active = false
	setLocButtonText("你在哪里？")
	locationButtonText.color = "#939393"
	locationButtonIcon.image = "images/locationRangeButtonImages/locGray.png"


# location & range button control
locationButtonBg.on Events.Click, ->
	locShow()

rangeButton.on Events.Click, ->


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

# loc control

locPositionReset = () ->
	locationScrollViewContent.y = 0

locVanish = () ->
	locationTitle.animate("vanish")
	locationScrollView.animate("vanish")
	locationHalf.backgroundColor = "transparent"
	locationScrollView.backgroundColor = "transparent"
	enableToolBar()
	showKeyboard()

locShow = () ->
	locPositionReset()
	locationTitle.animate("show")
	locationScrollView.animate("show")
	locationHalf.backgroundColor = "f6f6f6"
	locationScrollView.backgroundColor = "ffffff"
	disableToolBar()
	hideKeyboard()

locReset = () ->
	locationTitle.stateSwitch("vanish")
	locationScrollView.stateSwitch("vanish")
	locationHalf.backgroundColor = "transparent"
	locationScrollView.backgroundColor = "ffffff"
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

# locationhalf init
locationHalf.height += SpaceForiPhoneX
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


picReset()
locReset()
setLocButtonNormal()

# Keyboard Simulator
# Variables
lettersActive = true 
numbersActive = false
showLeftKey = false 
showRightKey = false
showLargeKey = false

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
	else
		setLowercase()
		
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
		input._inputElement.focus()
		
		if shiftIconActive.visible
			input.value += currentActiveLetter.text.toUpperCase()		
		else
			input.value += currentActiveLetter.text
			
		checkValue()
		input.emit(Events. ValueChange, input.value)
	
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
		input._inputElement.focus()
		input.value += currentActiveLetter.text
		input.emit(Events.InputValueChange, input.value)	
		if @name is '@'
			NameList.placeBehind(keyboard)
			NameList.animate
				opacity: 1
				
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

# Keyboard Controler

toolBar.originalYPosition = toolBar.y
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

# Names
names =['Akan', 'Arabic', 'Bulgarian', 'Czech', 'Dutch', 'England','Fijian', 'German', 'Hawaiian', 'Icelandic', 'Japanese', 'Korean', 'Lithuanian', 'Malaysian', 'Nana', 'Optimy', 'Philippine', 'Queen', 'Russian', 'Spanish', 'Taiwanese', 'Uper', 'Vietnamese','Walls', 'Xia', 'Yang', "Zeat"]

namesR = ['Daqian','Xiaohe', 'Xiaojing', 'Zhaoxi', 'Lulu']

# Name List settings
NameList.opacity = 0
NameList.sendToBack()
NameList.ignoreEvents = true
NameListHeight = 50
NameListDistance = 278
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
	sectionHeader = new Layer
		y: sectionIndex * NameListDistance
		width: NameList.width - 16, height:30
		parent: NameListView.content
		backgroundColor:"#F8F8F8"
		html: "#{characters[sectionIndex]}"
		style:
			paddingLeft:"16px", fontWeight: "250"
			lineHeight:"90px", fontSize:"17px", color: "black"
	sectionHeader.originalYPosition = sectionHeader.y
	sectionHeaders.push sectionHeader
	rowsPerSection = 5

	for rowIndex in [0...rowsPerSection]
		# A cell is created for the row
		if sectionIndex <= 0
			cell = new Layer
				name: namesR[rowIndex]#(sectionIndex + 1) * 10 + rowIndex
				x: 0
				y: rowIndex*NameListHeight
				width:NameList.width - 16, height:48
				backgroundColor:null
				style: borderBottom: "1px solid #E1E1E1"
				# The cell is put inside the content layer of the scroll component
				superLayer: NameListView.content
			cells.push(cell)
# 			print cell.name
			layer = new TextLayer
				text: namesR[rowIndex]
				parent: cell
				fontSize: 16, fontStyle: "PingFang SC", color: "#333", padding: top: 13,left: 13
		if sectionIndex >= 1
			cell = new Layer
				name: names[sectionIndex]#(sectionIndex + 1) * 10 + rowIndex
				x: 0
				y: 19 + (rowIndex*NameListHeight)+(sectionIndex*NameListDistance)
				width: NameList.width - 16, height:60
				backgroundColor:null
				style: borderBottom: "1px solid #E1E1E1"
				# The cell is put inside the content layer of the scroll component
				parent: NameListView.content
			layer = new TextLayer
				text: names[sectionIndex]
				parent: cell
				fontSize: 16, fontStyle: "PingFang SC", color: "#333", padding: top:23,left: 13
			cells.push(cell)
# 			print cell.name

# Input Names From NameList
for layer in cells
	layer.onClick ->
		return if NameListView.isDragging
		return if NameListView.isMoving
		input.value += @name + " "
		NameList.animate
			opacity: 0
		NameList.sendToBack()
		showKeyboard()
		Resetkeyboard()
		NameListView.scrollY = 0
	

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
			if yOffset > layer.originalYPosition + NameListDistance - NameListHeight + 19
				layer.y = layer.originalYPosition + NameListDistance - NameListHeight + 19
			else
				layer.y = yOffset
		else
			layer.y = layer.originalYPosition
	if NameListViewState = 1
		hideKeyboard()

# Input Topics
topics = ['食人的大鹫', '流行','雷神3：诸神黄昏', '每日桌面', '新浪总部大厦', "鹿晗",'30天英雄联盟挑战', '周总理逝世42周年', '河间驴肉火烧造假', 'V影响力峰会', '汪峰', '陈乔恩','挑一挑攻略', '守望先锋30天挑战', '人人网遭监管约谈', '李泽言0113生日快乐', '北京', '越听越痛的歌', '北京乐派', '南方的猪第一次看见雪', '亚洲新歌榜', '我的年度金曲', '跟着墩布挖白菜', '国家最高科技奖', '最晕路口37个红绿灯', '北京租房', '老公我要这个']

# Name List settings
TopicList.opacity = 0
TopicList.sendToBack()
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
		x: 0
		y: (sectionIndex*TopicListDistance)
		width: TopicList.width - 16, height:60
		backgroundColor:null
		style: borderBottom: "1px solid #E1E1E1"
		# The cell is put inside the content layer of the scroll component
		parent: TopicListView.content
	layer = new TextLayer
		text: topics[sectionIndex]
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
		TopicList.sendToBack()
		showKeyboard()
		Resetkeyboard()
		TopicListView.scrollY = 0

TopicListView.onScrollStart -> TopicListViewState = 1
TopicListView.onScrollEnd -> TopicListViewState = 0
TopicListView.onMove (event) ->
	if TopicListViewState = 1
		hideKeyboard()
		


bg.onClick -> showKeyboard()
