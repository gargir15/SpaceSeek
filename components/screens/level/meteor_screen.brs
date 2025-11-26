function init()
    ? "[meteor_screen] init"
    
    'initializing nodes
    m.question = m.top.findNode("question")
    m.bg = m.top.findNode("game_screen_bg")
    m.answers = m.top.findNode("answerButtonGroup")
    m.backButton = m.top.findNode("backButton")
    m.bonusPoints = m.top.findNode("bonusPoints")

    m.backButton.buttons = ["back"]
    
    'character nodes
    m.captainWolf = m.top.findNode("captainWolf")
    m.pepper = m.top.findNode("pepper")
    m.rocky = m.top.findNode("rocky")

    m.top.observeField("visible", "onVisibleChange")

    'fonts
    m.fonts2 = CreateObject("roSGNode", "Font")
    m.fonts2.uri = "pkg:/fonts/BubblePixel2.ttf"
    m.fonts2.size = 30
    m.bonusPoints.font = m.fonts2

    m.backButton.visible = false
    m.backButton.setFocus(false)

    m.character_bucket = m.captainWolf

    'indexes
    m.charIndex = m.global.character

    m.pepper.visible = false
    m.rocky.visible = false
    m.captainWolf.visible = false

    if m.charIndex = 0 then
        m.character_bucket = m.captainWolf

    else if m.charIndex = 1 then
        m.character_bucket = m.pepper

    else if m.charIndex = 2 then 
        m.character_bucket = m.rocky
    end if


    m.level1done = false
    m.level2done = false
    m.level3done = false

    m.rocket1 = m.top.findNode("rocket1")
    m.rocket2 = m.top.findNode("rocket2")
    m.rocket3 = m.top.findNode("rocket3")
    m.rocket4 = m.top.findNode("rocket4")
    m.rocket5 = m.top.findNode("rocket5")
    m.rocket6 = m.top.findNode("rocket6")
    m.rocket7 = m.top.findNode("rocket7")
    m.rocket8 = m.top.findNode("rocket8")

    m.testAnimation = m.top.findNode("testAnimation")
    m.testVector2D = m.top.findNode("testVector2D")

    m.shipPieceArray = CreateObject("roArray", 8, true)

    m.translationArray = CreateObject("roArray", 8, true)

    m.keyValueArray = CreateObject("roArray", 10, true)

    m.shipPieceArray.Push(m.rocket1)
    m.shipPieceArray.Push(m.rocket8)
    m.shipPieceArray.Push(m.rocket2)
    m.shipPieceArray.Push(m.rocket5)
    m.shipPieceArray.Push(m.rocket6)
    m.shipPieceArray.Push(m.rocket3)
    m.shipPieceArray.Push(m.rocket7)
    m.shipPieceArray.Push(m.rocket4)


    m.translationArray.Push("rocket1.translation")
    m.translationArray.Push("rocket8.translation")
    m.translationArray.Push("rocket2.translation")
    m.translationArray.Push("rocket5.translation")
    m.translationArray.Push("rocket6.translation")
    m.translationArray.Push("rocket3.translation")
    m.translationArray.Push("rocket7.translation")
    m.translationArray.Push("rocket4.translation")

    m.keyValueArray.Push("[[243, 0], [243, 350.0], [243, 750]]")
    m.keyValueArray.Push("[[500, 0], [500, 350.0], [500, 750]]")
    m.keyValueArray.Push("[[120, 0], [120, 350.0], [120, 750]]")
    m.keyValueArray.Push("[[754, 0], [754, 350.0], [754, 750]]")
    m.keyValueArray.Push("[[352, 0], [352, 350.0], [352, 750]]")
    m.keyValueArray.Push("[[843, 0], [843, 350.0], [843, 750]]")
    m.keyValueArray.Push("[[490, 0], [490, 350.0], [490, 750]]")
    m.keyValueArray.Push("[[631, 0], [631, 350.0], [631, 750]]")
    m.keyValueArray.Push("[[1023, 0], [1023, 350.0], [1023, 750]]")
    m.keyValueArray.Push("[[845, 0], [845, 350.0], [845, 750]]")


    m.character_bucket.visible = true
    m.rocket1.visible = true 
    m.label = m.top.findNode("label")
    m.index = 0
    m.spaceShip = m.shipPieceArray[0]
    m.testAnimation.control = "start"
    m.index2 = 0
end function


sub onVisibleChange() 
    if m.top.visible = true then
        m.bonusPoints.text = "Points: " + ToString(m.global.Allpoints)
    end if
end sub


function onKeyEvent(key as String, press as Boolean) as Boolean 
    m.spaceShip.visible = true
    m.spaceShip.setFocus(true)

    'finds the midpoint of the images with y and x :p
    'moves character to the right
    if key = "right"
        m.character_bucket.translation = [m.character_bucket.translation[0] + 10, m.character_bucket.translation[1]]
        'moves character to the left
    else if key = "left"
       m.character_bucket.translation = [m.character_bucket.translation[0] - 10, m.character_bucket.translation[1]]
    end if
    m.characterX = midPoint(m.character_bucket.translation[0], m.character_bucket.translation[0] + m.character_bucket.width)
    m.characterY = midPoint(m.character_bucket.translation[1], m.character_bucket.translation[1]+ m.character_bucket.height)
    m.spaceShipX = midPoint(m.spaceShip.translation[0], m.spaceShip.translation[0] + m.spaceShip.width)
    m.spaceShipY = midPoint(m.spaceShip.translation[1], m.spaceShip.translation[1]+ m.spaceShip.height)

    'when the piece reaches the character
    if m.characterX > m.spaceShipX - 60 and m.characterX < m.spaceShipX + 60 and m.characterY > m.spaceShipY - 25 and m.characterY < m.spaceShipY + 25
        m.spaceShip.visible = false
        m.testAnimation.control = "stop"   
    end if 
    'if the character catches the piece :)
    if  m.testAnimation.state = "stopped" and m.characterX > m.spaceShipX - 60 and m.characterX < m.spaceShipX + 60 and m.characterY > m.spaceShipY - 25 and m.characterY < m.spaceShipY + 25
        if (m.index + 1) = 8
            m.index = 0
        end if 
        if (m.index2 + 1) = 10
            m.index2 = 0
        end if 
        if (m.index = 7)
            m.global.Allpoints = m.global.Allpoints + 10
             m.bonusPoints.text= "Points: " + ToString(m.global.Allpoints)
        else 
            m.global.Allpoints = m.global.Allpoints + 5
            m.bonusPoints.text= "Points: " + ToString(m.global.Allpoints)
        end if 
        m.index = m.index + 1
        m.index2 = m.index2 + 1
        m.testVector2D.fieldToInterp = m.translationArray[m.index]
        m.testVector2D.keyValue = m.keyValueArray[m.index2]
        m.testAnimation.control = "start"
        m.spaceShip = m.shipPieceArray[m.index]
        m.spaceShip.visible = true
    end if 
    'if the character doesnt catch the piece :(
    if m.testAnimation.state = "stopped"
        if (m.index + 1) = 8
            m.index = 0
        end if 
        if (m.index2 + 1) = 10
            m.index2 = -1
        end if 
        m.index = m.index + 1
        m.index2 = m.index2 + 1
        m.testVector2D.fieldToInterp = m.translationArray[m.index]
        m.testVector2D.keyValue = m.keyValueArray[m.index2]
        m.testAnimation.control = "start"
        m.spaceShip = m.shipPieceArray[m.index]
        m.spaceShip.visible = true
    end if 

end function 


function midPoint(num1, num2)
    m.point = (num1 + num2)/2
    return m.point
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