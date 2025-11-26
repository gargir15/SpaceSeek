function init()
    ? "[level_3_screen] init"
    
    'initializing nodes
    m.error_dialog = m.top.findNode("error_dialog")
    m.error_dialog.title = ""
    m.error_dialog.message = ""

    m.question = m.top.findNode("question")
    m.bg = m.top.findNode("level_3_screen_bg")
    m.answers3 = m.top.findNode("answer3ButtonGroup")
    m.back3 = m.top.findNode("backButton3")
    m.pointsLabel = m.top.findNode("pointsLabel")
    m.video = m.top.findNode("video")
    m.rect = m.top.findNode("whiterecGameScreen")
     m.rect2 = m.top.findNode("whiterecGameScreen2")

    m.pointsLabel.text= "points: " + ToString(m.global.Allpoints)

    m.back3.buttons = ["Back"]

    'character nodes
    m.captainWolf = m.top.findNode("captainWolf")
    m.pepper = m.top.findNode("pepper")
    m.rocky = m.top.findNode("rocky")

    'json objects
    m.jsonData = CreateObject("roSGNode", "LoadFeedTask")
    m.jsonData.observeField("response", "onJsonData")
    
    'answer button group buttons + visibility
    m.answers3.buttons = ["option 1", "option 2", "option 3"] 
    m.top.observeField("visible", "onVisibleChange")
    m.answers3.setFocus(false)
    m.answers3.visible = false

    m.back3.visible = false
    m.back3.setFocus(false)

    'error dialog visibility
    reset_dialog()
    m.answers3.observeField("buttonSelected", "onAnsSelected")

    'indexes
    m.charIndex = 0
    m.corrAns = 0
    m.points = 0

    m.levelDone = false

    'fonts
    m.fonts = CreateObject("roSGNode", "Font")
    m.fonts.uri = "pkg:/fonts/font2.ttf"
    m.fonts.size = 20

    m.fonts2 = CreateObject("roSGNode", "Font")
    m.fonts2.uri = "pkg:/fonts/BubblePixel2.ttf"
    m.fonts2.size = 30
    
    m.answers3.textFont = m.fonts
    m.answers3.focusedTextFont = m.fonts
    m.back3.textFont = m.fonts
    m.question.font = m.fonts
    
    m.back3.focusedTextFont = m.fonts2
    m.pointsLabel.font = m.fonts2

    fetchJson3Data("level3Q1.json")
end function


sub onVisibleChange()
    ? "onVisibleChange function for level 3 called"

    if m.top.visible = true then
        m.pointsLabel.text= "points: " + ToString(m.global.Allpoints)
        m.error_dialog.setFocus(false)

        m.back3.visible = false
        m.back3.setFocus(false)

        m.question.visible = true
        m.answers3.visible = true
        m.answers3.setFocus(true)
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
            m.answers3.setFocus(true)
            return true
        end if
    end if
end function


sub onAnsSelected()
    answerIndex = m.answers3.buttonSelected
    ? "Selected answer index: "; answerIndex
    ? "Correct answer index: "; m.jsonResponse.correctAns
    
    if m.question.visible = true then 
        if answerIndex = m.jsonResponse.correctAns
            showErrorDialog("Good job! You picked the right answer! Click back to move on.", "Correct", "https://kingsfortress-3e1c1a41ac2a.herokuapp.com/images/green.png")
            ? "correct answer"

            m.points = m.global.Allpoints + 10
            AddAndSetFields(m.global, {Allpoints: m.points})
            m.pointsLabel.text= "points: " + ToString(m.points)

            if m.jsonResponse.num = 3
                m.corrAns = 1
                m.levelDone = true
                AddAndSetFields(m.global, {correctAns3: m.corrAns})
                AddAndSetFields(m.global, {level3complete: m.levelDone})
                playExitVideo()
            else
                nextQuestion()
            end if
        else 
                showErrorDialog("You picked the wrong answer. Try again! Click back to move on.", "Incorrect", "https://kingsfortress-3e1c1a41ac2a.herokuapp.com/images/red.png")
                m.points = m.global.Allpoints - 5
                AddAndSetFields(m.global, {Allpoints: m.points})
                m.pointsLabel.text= "points: " + ToString(m.points)
        end if
    end if
end sub


sub nextQuestion()
    if m.jsonResponse.num = 3 'if it is on the last question
        reset_screen()
    else
        fetchJson3Data(m.jsonResponse.optionpath)
        m.answers3.setFocus(true)
    end if
end sub


sub reset_screen()
    m.answers3.visible = false
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


sub reset_dialog()
    m.error_dialog.visible = false
    m.error_dialog.setFocus(false)
end sub


sub fetchJson3Data(path)
    ? "fetchJson3Data: "; path
    m.jsonData.url = "https://kingsfortress-3e1c1a41ac2a.herokuapp.com/jsons/" + path
    m.jsonData.control = "run"
end sub


sub onJsonData()
    response = m.jsonData.response
    ? "Received JSON response: " + response
    if response <> invalid and response <> ""
        m.jsonResponse = ParseJson(response)
        if m.jsonResponse <> invalid
            m.answers3.buttons = [m.jsonResponse.option1, m.jsonResponse.option2, m.jsonResponse.option3]
            m.question.text = m.jsonResponse.question
            m.bg.uri = m.jsonResponse.background
            if m.top.visible then
                m.answers3.setFocus(true)
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
    preloadVideo(m.video, "pkg:/images/third.mov")
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
        m.back3.visible = true
        m.back3.setFocus(true)
        m.bg.uri = "https://kingsfortress-3e1c1a41ac2a.herokuapp.com/images/level_three_bg.png"
    end if
end sub