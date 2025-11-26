function init()
    ? "[characters_screen] Init"
    m.charIndex = -1
    ? "Initial Char Index val: "; m.charIndex

    ' Set focus to the top-level component
    m.top.setFocus(true)

    m.bg = m.top.findNode("costumeBG")
    m.error_dialog = m.top.findNode("error_dialog")


    ' Observe visibility changes of the screen
    m.top.observeField("visible", "onVisibleChange")

    'Allows user to move through the list
    'm.category_list.observeField("buttonSelected", "onCharacterSelected")

    m.character_list = m.top.findNode("character_list")

    m.character_list.buttons=["Captain Wolf", "Pepper", "Rocky"]
    m.characterRect = m.character_list.boundingRect()

    m.character_list.observeField("buttonSelected", "onButtonSelected")

    characterButton = CreateObject("roSGNode", "Font")
    characterButton.uri = "pkg:/fonts/BubblePixel2.ttf"
    characterButton.size = 32


    m.character_list.textFont = characterButton
    m.character_list.focusedTextFont = characterButton

    m.character_list.setFocus(true)
    m.character_list.focusButton = 0

    m.charaindex = 0


end function

'sub onCharacterSelected()
    '? "onCategorySelected field: "; obj.getField()
    '? "onCategorySelected data: "; obj.getData()

   ' m.buttonIndex = m.category_list.buttonSelected
'end sub

sub onVisibleChange()
     'When the screen is visible, set focus to the wolf button
    if m.top.visible = true then
        m.character_list.setFocus(true)
    end if
end sub


function onButtonSelected()
    m.charSelectIndex = m.character_list.buttonSelected
    ? "in character screen, index", m.charSelectIndex
    AddAndSetFields(m.global, {character: m.charSelectIndex})
    showErrorDialog("Your character has been updated!", "NEW CHARACTER")
end function


function onKeyEvent(key as String, press as Boolean) as Boolean
    if press = true then 

        if key = "right"
            m.charaindex = m.charaindex + 1

            if m.charaindex > 2
                m.charaindex = 0
            end if

            m.character_list.focusButton = m.charaindex
            return true

        else if key = "left"
            m.charaindex = m.charaindex - 1

            if m.charaindex < 0 
                m.charaindex = 2
            end if

            m.character_list.focusButton = m.charaindex
            return true

        else if key = "up"

            m.character_list.focusButton = m.charaindex  
            return true

        else if key = "down"

            m.character_list.focusButton = m.charaindex
            return true

        end if 
    end if
    return false
end function


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


sub showErrorDialog(message, title)
	m.error_dialog.title = title
	m.error_dialog.message = message
	m.error_dialog.visible=true
	'tell the home scene to own the dialog so the remote behaves'
	m.top.dialog = m.error_dialog
end sub