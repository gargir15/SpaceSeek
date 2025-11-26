function init()
    ? "[level_2_screen] init"
    
    'initializing nodes
    m.error_dialog = m.top.findNode("error_dialog")
    m.error_dialog.title = ""
    m.error_dialog.message = ""

    m.question = m.top.findNode("question")
    m.bg = m.top.findNode("level_2_screen_bg")
    m.answers2 = m.top.findNode("answer2ButtonGroup")
    m.back2 = m.top.findNode("backButton2")
    m.video = m.top.findNode("video")
    m.rect = m.top.findNode("whiterecGameScreen")
    m.rect2 = m.top.findNode("whiterecGameScreen2")
    m.pointsLabel = m.top.findNode("pointsLabel")

    m.back2.buttons = ["Back"]
    
    'character nodes
    m.captainWolf = m.top.findNode("captainWolf")
    m.pepper = m.top.findNode("pepper")
    m.rocky = m.top.findNode("rocky")

    'json objects
    m.jsonData = CreateObject("roSGNode", "LoadFeedTask")
    m.jsonData.observeField("response", "onJsonData")
    
    'answer button group buttons + visibility
    m.answers2.buttons = ["option 1", "option 2", "option 3"] 
    m.top.observeField("visible", "onVisibleChange")
    m.answers2.setFocus(false)
    m.answers2.visible = false

    m.back2.visible = false
    m.back2.setFocus(false)

    'error dialog visibility
    reset_dialog()
    m.answers2.observeField("buttonSelected", "onAnsSelected")

    'indexes
    m.charIndex = 0
    m.corrAns = 0

    'fonts
    m.fonts = CreateObject("roSGNode", "Font")
    m.fonts.uri = "pkg:/fonts/font2.ttf"
    m.fonts.size = 20

    m.fonts2 = CreateObject("roSGNode", "Font")
    m.fonts2.uri = "pkg:/fonts/BubblePixel2.ttf"
    m.fonts2.size = 30
    
    m.answers2.textFont = m.fonts
    m.answers2.focusedTextFont = m.fonts
    m.back2.textFont = m.fonts2
    m.question.font = m.fonts
    
    m.back2.focusedTextFont = m.fonts2
    m.pointsLabel.font = m.fonts2
    
    fetchJson2Data("level2Q1.json")
end function


sub onVisibleChange()
    ? "onVisibleChange function for level 2 called"

    if m.top.visible = true then
        m.error_dialog.setFocus(false)
        m.pointsLabel.text= "points: " + ToString(m.global.Allpoints)

        m.back2.visible = false
        m.back2.setFocus(false)

        m.question.visible = true
        m.answers2.visible = true
        m.answers2.setFocus(true)
    end if

    if m.global.character <> invalid
        m.charIndex = m.global.character
    end if

    if m.charIndex = 0 then
        m.pepper.visible = false
        m.rocky.visible = false
        m.captainWolf.visible = true

    else if m.charIndex = 1 then
        m.captainWolf.visible = false
        m.rocky.visible = false
        m.pepper.visible = true
        
    else if m.charIndex = 2 then 
        m.captainWolf.visible = false
        m.pepper.visible = false
        m.rocky.visible = true
    end if
end sub


function onKeyEvent(key, press) as Boolean
    ? "[game_screen] onKeyEvent", key, press
    if m.top.visible then
        if key = "OK"
            return true
        end if 
        if key = "back" and press
            reset_dialog()
            m.answers2.setFocus(true)
            return true
        end if
    end if
end function


sub onAnsSelected()
    answerIndex = m.answers2.buttonSelected
    ? "Selected answer index: "; answerIndex
    ? "Correct answer index: "; m.jsonResponse.correctAns
    
    if m.question.visible = true then 
        if answerIndex = m.jsonResponse.correctAns
                showErrorDialog("Good job! You picked the right answer! Click back to move on.", "Correct", "https://kingsfortress-3e1c1a41ac2a.herokuapp.com/images/green.png")
            ? "correct answer"
            m.points = m.global.Allpoints + 10
            AddAndSetFields(m.global, {Allpoints: m.points})
            m.pointsLabel.text = "points: " + ToString(m.points)

            if m.jsonResponse.num = 3
               ' m.back2.visible = true
                'm.back2.setFocus(true)
                m.corrAns = 1
                AddAndSetFields(m.global, {correctAns2: m.corrAns})
                playExitVideo()

            else
                nextQuestion()
            end if
        else 
            showErrorDialog("You picked the wrong answer. Try again! Click back to move on.", "Incorrect", "https://kingsfortress-3e1c1a41ac2a.herokuapp.com/images/red.png") 
            m.points = m.global.Allpoints - 5
            AddAndSetFields(m.global, {Allpoints: m.points})
            m.pointsLabel.text = "points: " + ToString(m.points)
        end if
    end if
end sub


sub nextQuestion()
    if m.jsonResponse.num = 3 'if it is on the last question
        reset_screen()
    else
        fetchJson2Data(m.jsonResponse.optionpath)
        m.answers2.setFocus(true)
    end if
end sub


sub reset_dialog()
    m.error_dialog.visible = false
    m.error_dialog.setFocus(false)
end sub


sub reset_screen()
    m.answers2.visible = false
    m.question.visible = false
    m.bg.uri = "pkg:/images/notexist.png"
    m.pepper.visible = false
    m.rocky.visible = false
    m.captainWolf.visible = false
    m.error_dialog.visible = false
    m.pointsLabel.visible = false
    m.rect.visible = false
    m.rect2.visible = false
end sub


sub fetchJson2Data(path)
    ? "fetchJson2Data: "; path
    m.jsonData.url = "https://kingsfortress-3e1c1a41ac2a.herokuapp.com/jsons/" + path
    m.jsonData.control = "run"
end sub


sub onJsonData()
    response = m.jsonData.response
    ? "recieved json response: " + response
    if response <> invalid and response <> ""
        m.jsonResponse = ParseJson(response)
        if m.jsonResponse <> invalid
            m.answers2.buttons = [m.jsonResponse.option1, m.jsonResponse.option2, m.jsonResponse.option3]
            m.question.text = m.jsonResponse.question
            m.bg.uri = m.jsonResponse.background
            if m.top.visible then
                m.answers2.setFocus(true)
            end if
        else
            ? "DID NOT PARSE..."
        end if
    else 
        ? "could not find file..."
    end if  
end sub

sub showErrorDialog(message, title, ur)
	m.error_dialog.title = title
	m.error_dialog.message = message
	m.error_dialog.visible = true
    m.error_dialog.backgroundUri= ur
	'tell the home scene to own the dialog so the remote behaves...
	m.top.error_dialog = m.error_dialog
    m.error_dialog.titleFont = m.fontofButtons
    ? "Error dialog shown with title: "; title; " and message: "; message
end sub


function AddAndSetFields( node as object, aa as object )
    addFields = {}
    setFields = {}
    for each field in aa
      if node.hasField( field )
        setFields[ field ] = aa[ field ]
      else
        addFields[ field ] = aa[ field ]
      end if
    end for

    node.setFields( setFields )
    node.addFields( addFields )
end function

Function ToString(variable As Dynamic) As String
    If Type(variable) = "roInt" Or Type(variable) = "roInteger" Or Type(variable) = "roFloat" Or Type(variable) = "Float" Then
        Return Str(variable).Trim()
    Else If Type(variable) = "roBoolean" Or Type(variable) = "Boolean" Then
        If variable = True Then
            Return "True"
        End If
        Return "False"
    Else If Type(variable) = "roString" Or Type(variable) = "String" Then
        Return variable
    Else
        Return Type(variable)
    End If
End Function


function preloadVideo(videoNode, videoUrl)
    ? "Preloading video: "; videoUrl
    videoContent = CreateObject("roSGNode", "ContentNode")
    videoContent.url = videoUrl
    videoContent.streamFormat = "mp4"
    
    videoNode.content = videoContent
    videoNode.observeField("state", "onVideoPreloadStateChange")
    videoNode.control = "preload"
end function


sub onVideoPreloadStateChange(event as Object)
    ? "Video preload state: "; event.getData()
    if event.getData() = "preloaded"
        ? "Video preloaded successfully"
    else if event.getData() = "error"
        ? "Error preloading video"
    end if
end sub


function playExitVideo()
    ? "inside the playExitVideo function"
    preloadVideo(m.video, "pkg:/images/second.mov")
    reset_screen()
    m.video.visible = true
    m.video.control = "play"
    m.video.setFocus(true)
    m.video.observeField("state", "onVideoStateChange")
end function


sub onVideoStateChange()
    if m.video.state = "finished"
        ? "m.video.state finished"
        m.video.visible = false
        m.back2.visible = true
        m.back2.setFocus(true)
        m.bg.uri = "https://kingsfortress-3e1c1a41ac2a.herokuapp.com/images/level_two_bg.png"
    end if
end sub