function init()
    ? "[level_screen] Init"
    m.header = m.top.findNode("header")

    'm.bg = m.top.findNode("costumeBG")

    m.top.observeField("visible", "onVisibleChange")

    m.game_screen = m.top.findNode("game_screen")
    m.levelButtons = m.top.findNode("levelButtons")
    m.meteorButton = m.top.findNode("meteorButton")

    'fonts
    m.fonts = CreateObject("roSGNode", "Font")
    m.fonts.uri = "pkg:/fonts/BubblePixel2.ttf"
    m.fonts.size = 30
    
    m.meteorButton.buttons=["BONUS"]
    m.meteorButton.textFont= m.fonts
    m.meteorButton.focusedTextFont = m.fonts

    level3Done = false

end function

function onVisibleChange()
    if m.top.visible = true then
      ? "correctAns1: "; m.global.correctAns1
      ? "correctAns2: "; m.global.correctAns2
      ? "correctAns3: "; m.global.correctAns3

      if m.global.level3complete <> invalid
          m.level3Done = m.global.level3complete
      end if

      if m.level3Done = true then
          if m.global.correctAns2 + m.global.correctAns3 + m.global.correctAns1 = 3 then 
            m.meteorButton.visible = true
            m.meteorButton.setFocus(true)

            ? "meteor button showed up"
            
          end if 
      end if

    end if
end function
