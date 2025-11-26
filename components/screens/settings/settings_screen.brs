function init()
  'onClick="https://kingsfortress-3e1c1a41ac2a.herokuapp.com/images/focusedPawPrint_resized.png"
  'onClick="https://kingsfortress-3e1c1a41ac2a.herokuapp.com/images/focusedPawPrint_resized.png"
  m.header = m.top.findNode("header")
  'm.top.observeField("visible", "onVisibleChange")

  'fonts
  fontofButtons = CreateObject("roSGNode", "Font")
  fontofButtons.uri = "pkg:/fonts/BubblePixel2.ttf"
  fontofButtons.size = 32
   
  'm.settings_list.textFont = fontofButtons
  'm.settings_list.focusedTextFont = fontofButtons
  'm.settings_list.observeField("itemSelected", "onSettingsButtonSelected")

  'm.fontSizeButtons.observeField("itemSelected", "onFontSizeButtonSelected")

  'm.settings_list.setFocus(true)
  'm.settings_list.focusButton = 0
end function


sub onVisibleChange()
  if m.top.visible = true then
    m.header.setFocus(true)
    m.settings_list.setFocus(true)
  end if
end sub


sub onSettingsButtonSelected(obj)
    m.settingsButtonIndex = m.setting_list.buttonSelected
    ? "onSettingsButtonSelected is being called"

    if m.settingsButtonIndex = 0 'text size is clicked
        m.settings_list.visible = false
        m.fontSizeButtons.visible = true
        m.fontSizeButtons.setFocus(true)
        
    else if m.settingsButtonIndex = 1 'language thing
        'nothing for rn
    end if

end sub


sub onFontSizeButtonSelected(obj)
    ? "font size button option was selected"
    m.fontButtonIndex = m.fontSizeButtons.buttonSelected

    if m.fontButtonIndex = 0 'increase is selected
      'lalala
    else if m.fontButtonIndex = 1 'decrease is selected
      'lalal
    end if

end sub


'sub onIncreaseFontSizeClick()
 ' local currentFontSize = getFontSize()  
  'local newFontSize = currentFontSize + 2
  'setFontSize(newFontSize) 
'end sub


'sub onDecreaseFontSizeClick()
 ' local currentFontSize = getFontSize()
  'local newFontSize = currentFontSize - 2
  'setFontSize(newFontSize)
'end sub


function getFontSize()
  return 20  
end function